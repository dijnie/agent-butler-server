import Fly from 'flyio/dist/npm/fly';
import store from '../store/index';
import Constant from '../utils/constant';
import { getServiceUrl } from '../apis/api';
import { goToPage, isNotNull, showDanger, showWarning } from '../utils/index';
import i18n from '../i18n/index';

const fly = new Fly()
// Set timeout
fly.config.timeout = 30000

// A separate fly instance for silent refresh, so that no callback chain leads back to sendRequest
const refreshFly = new Fly()
refreshFly.config.timeout = 30000

// silent refresh: swap the token when 1h remains; a single-flight lock avoids concurrency
const REFRESH_AHEAD_MS = 60 * 60 * 1000
let refreshPromise = null

function getTokenExpireAt() {
    // Read localStorage from the same source as persistTokenExpireAt (the store goes through the state.token cache,
    // so right after writing localStorage the store cannot see the back-filled _localStoredAt)
    const raw = localStorage.getItem('token')
    if (!raw) return 0
    try {
        const parsed = JSON.parse(raw)
        if (!parsed || !parsed.expire) return 0
        // login.vue writes to the store with setToken(now), and the token object has no createdAt;
        // use _localStoredAt as the baseline for the local storage time
        return (parsed._localStoredAt || 0) + parsed.expire * 1000
    } catch (e) {
        return 0
    }
}

// Record the storage time the first time this token is seen; refresh localStorage and the store together to keep both sides consistent
function persistTokenExpireAt() {
    const raw = localStorage.getItem('token')
    if (!raw) return
    try {
        const parsed = JSON.parse(raw)
        if (parsed && parsed.expire && !parsed._localStoredAt) {
            parsed._localStoredAt = Date.now()
            const next = JSON.stringify(parsed)
            localStorage.setItem('token', next)
            store.commit('setToken', next)
        }
    } catch (e) { /* ignore */ }
}

function shouldRefresh() {
    persistTokenExpireAt()
    const exp = getTokenExpireAt()
    if (!exp) return false
    return exp - Date.now() < REFRESH_AHEAD_MS
}

function doRefresh() {
    // Go through fly.request directly, bypassing sendRequest, to avoid an infinite loop triggering silent refresh
    const raw = localStorage.getItem('token')
    if (!raw) return Promise.reject(new Error('no token'))
    let bearer
    try {
        bearer = JSON.parse(raw).token
    } catch (e) {
        return Promise.reject(e)
    }
    return refreshFly.request(getServiceUrl() + '/user/refresh', {}, {
        method: 'POST',
        headers: { Authorization: 'Bearer ' + bearer }
    }).then((res) => {
        const body = res && res.data
        if (!body || (body.code !== 0 && body.code !== 'success')) {
            throw new Error('refresh failed: ' + (body && body.msg))
        }
        const newDto = body.data
        newDto._localStoredAt = Date.now()
        store.commit('setToken', JSON.stringify(newDto))
        return newDto
    })
}

function triggerSilentRefresh() {
    if (!refreshPromise) {
        refreshPromise = doRefresh().catch((err) => {
            store.commit('clearAuth')
            goToPage(Constant.PAGE.LOGIN, true)
            throw err
        }).finally(() => {
            refreshPromise = null
        })
    }
    return refreshPromise
}

/**
 * Request service wrapper
 */
export default {
    sendRequest,
    reAjaxFun,
    clearRequestTime,
    triggerSilentRefresh
}

function sendRequest() {
    return {
        _sucCallback: null,
        _failCallback: null,
        _networkFailCallback: null,
        _method: 'GET',
        _data: {},
        _header: { 'content-type': 'application/json; charset=utf-8' },
        _url: '',
        _responseType: undefined, // Added response type field
        'send'() {
            // Set the language request header
            const currentLang = i18n.locale;
            // Convert the language code format, turning zh_CN into zh-CN
            let acceptLanguage = currentLang.replace('_', '-');
            // Add the default region code for English
            if (acceptLanguage === 'en') {
                acceptLanguage = 'en-US';
            }
            this._header['Accept-Language'] = acceptLanguage;

            const doSend = () => {
                if (isNotNull(store.getters.getToken)) {
                    this._header.Authorization = 'Bearer ' + (JSON.parse(store.getters.getToken)).token
                }

                // Print request information
                fly.request(this._url, this._data, {
                    method: this._method,
                    headers: this._header,
                    responseType: this._responseType
                }).then((res) => {
                    const error = httpHandlerError(res, this._failCallback, this._networkFailCallback);
                    if (error) {
                        return
                    }

                    if (this._sucCallback) {
                        this._sucCallback(res)
                    }
                }).catch((res) => {
                    // Print the failed response
                    console.log('catch', res)
                    httpHandlerError(res, this._failCallback, this._networkFailCallback)
                })
            }

            // If it expires within 1h, silent refresh first and then send, so the request carries the new token
            if (shouldRefresh()) {
                triggerSilentRefresh().then(doSend).catch(() => {
                    // Intercepted and redirected to login after triggering refresh; nothing to do here
                })
            } else {
                doSend()
            }
            return this
        },
        'success'(callback) {
            this._sucCallback = callback
            return this
        },
        'fail'(callback) {
            this._failCallback = callback
            return this
        },
        'networkFail'(callback) {
            this._networkFailCallback = callback
            return this
        },
        'url'(url) {
            if (url) {
                url = url.replaceAll('$', '/')
            }
            this._url = url
            return this
        },
        'data'(data) {
            this._data = data
            return this
        },
        'method'(method) {
            this._method = method
            return this
        },
        'header'(header) {
            this._header = header
            return this
        },
        'showLoading'(showLoading) {
            this._showLoading = showLoading
            return this
        },
        'async'(flag) {
            this.async = flag
        },
        // Added method for setting the type
        'type'(responseType) {
            this._responseType = responseType;
            return this;
        }
    }
}

/**
 * Info The information returned after the request completes
 * failCallback Callback function
 * networkFailCallback Callback function
 */
// Add logging in the error handler
function httpHandlerError(info, failCallback, networkFailCallback) {

    /** Request succeeded, exit this function. Whether a request succeeded can be decided according to project needs. Here status 200 is treated as success */
    let networkError = false
    if (info.status === 200) {
        if (info.data.code === 'success' || info.data.code === 0 || info.data.code === undefined) {
            return networkError
        } else if (info.data.code === 401) {
            store.commit('clearAuth');
            goToPage(Constant.PAGE.LOGIN, true);
            return true
        } else {
            // Use the internationalized message returned by the backend directly
            let errorMessage = info.data.msg;
            
            if (failCallback) {
                failCallback(info)
            } else {
                showDanger(errorMessage)
            }
            return true
        }
    }
    if (networkFailCallback) {
        networkFailCallback(info)
    } else {
        showDanger(`A network request error occurred [${info.status}]`)
    }
    return true
}

let requestTime = 0
let reAjaxSec = 2

function reAjaxFun(fn) {
    let nowTimeSec = new Date().getTime() / 1000
    if (requestTime === 0) {
        requestTime = nowTimeSec
    }
    let ajaxIndex = parseInt((nowTimeSec - requestTime) / reAjaxSec)
    if (ajaxIndex > 10) {
        showWarning('Unable to connect to the server')
    } else {
        showWarning('Connecting to the server (' + ajaxIndex + ')')
    }
    if (ajaxIndex < 10 && fn) {
        setTimeout(() => {
            fn()
        }, reAjaxSec * 1000)
    }
}

function clearRequestTime() {
    requestTime = 0
}