import os
import base64
import asyncio
import functools
import threading
import traceback
from typing import Optional, Dict

import httpx

TAG = __name__

# Slice granularity of _retry_wait: wraps up within ~100ms after safe_close; polling overhead is negligible
_RETRY_WAIT_SLICE = 0.1


class DeviceNotFoundException(Exception):
    pass


class DeviceBindException(Exception):
    def __init__(self, bind_code):
        self.bind_code = bind_code
        super().__init__(f"Device binding error, bind code: {bind_code}")


class ManageApiShutdownError(Exception):
    """Wrap-up exception raised after safe_close interrupts a retry wait; __cause__ keeps the last failure reason."""


class ManageApiClient:
    _instance = None
    _instance_lock = threading.Lock()  # Protects reads and writes of _instance and _closed
    _secret = None
    _closed = False  # Set to True after safe_close(); no new connections are created once closed

    def __new__(cls, config):
        """Singleton pattern ensuring a single global instance; supports passing in config parameters"""
        with cls._instance_lock:
            if cls._instance is None:
                cls._instance = super().__new__(cls)
                cls._init_client(config)
            return cls._instance

    @classmethod
    def _init_client(cls, config):
        """Initialize the config (the client is created lazily)"""
        cls.config = config.get("manager-api")

        if not cls.config:
            raise Exception("manager-api configuration error")

        if not cls.config.get("url") or not cls.config.get("secret"):
            raise Exception("manager-api url or secret is misconfigured")

        if "你" in cls.config.get("secret"):
            raise Exception("Please configure the manager-api secret first")

        cls._secret = cls.config.get("secret")
        cls.max_retries = cls.config.get("max_retries", 6)  # Maximum number of retries
        cls.retry_delay = cls.config.get("retry_delay", 10)  # Initial retry delay (seconds)
        # Do not create the AsyncClient here; defer creation until it is actually used
        cls._closed = False

    @classmethod
    def _build_client(cls) -> httpx.AsyncClient:
        """Build an AsyncClient dedicated to a single business request (including retries).

        Constraint: the caller closes it with ``async with`` in the same loop; caching across requests is forbidden. Construction happens outside the lock so concurrent requests do not block the event loop.
        """
        with cls._instance_lock:
            if cls._closed:
                raise Exception("ManageApiClient is closed; no new HTTP clients will be created")
            base_url = cls.config.get("url")
            secret = cls._secret
            timeout = cls.config.get("timeout", 30)
        return httpx.AsyncClient(
            base_url=base_url,
            headers={
                "User-Agent": f"PythonClient/2.0 (PID:{os.getpid()})",
                "Accept": "application/json",
                "Authorization": "Bearer " + secret,
            },
            timeout=timeout,
            # Connection reuse is limited to this request; keepalive_expiry dynamically covers retry_delay,
            # so pooled connections do not expire during a retry wait.
            limits=httpx.Limits(
                max_keepalive_connections=1,
                keepalive_expiry=max(30, cls.retry_delay + 5),
            ),
            trust_env=False,
            # verify=True builds a fresh context: httpcore rewrites the passed-in context in place
            # when connecting (no lock), so a shared singleton would race on concurrent handshakes.
            verify=True,
        )

    @classmethod
    async def _async_request(
        cls, client: httpx.AsyncClient, method: str, endpoint: str, **kwargs
    ) -> Dict:
        """Perform a single request on the given client; the response is released back to the pool right after it is read."""
        endpoint = endpoint.lstrip("/")
        response = None
        try:
            response = await client.request(method, endpoint, **kwargs)
            response.raise_for_status()
            result = response.json()
            if result.get("code") == 10041:
                raise DeviceNotFoundException(result.get("msg"))
            elif result.get("code") == 10042:
                raise DeviceBindException(result.get("msg"))
            elif result.get("code") != 0:
                raise Exception(f"API returned an error: {result.get('msg', 'Unknown error')}")
            return result.get("data")
        finally:
            if response is not None:
                try:
                    await response.aclose()
                except Exception:
                    # Constraint: release exceptions must be swallowed so they do not mask the business exception or break the retry decision
                    pass

    @classmethod
    def _should_retry(cls, exception: Exception) -> bool:
        """Decide whether the exception should be retried"""
        # Network connection errors
        if isinstance(
            exception, (httpx.ConnectError, httpx.TimeoutException, httpx.NetworkError)
        ):
            return True

        # For RPE only the "without sending a response" variant (response not started, safe) is retried;
        # the truncated variant may already have processed the request and would resubmit it; if the wording changes this degrades to no retry.
        if isinstance(exception, httpx.RemoteProtocolError):
            return "without sending a response" in str(exception)

        # HTTP status code errors
        if isinstance(exception, httpx.HTTPStatusError):
            status_code = exception.response.status_code
            return status_code in [408, 429, 500, 502, 503, 504]

        return False

    @classmethod
    async def _retry_wait(cls):
        """Retry wait that safe_close() can interrupt (polls _closed in 100ms slices).

        Constraint: never sleep the full retry_delay in one go, otherwise wrap-up after close drags on for a whole retry period.
        """
        remaining = cls.retry_delay
        while remaining > 0 and not cls._closed:
            step = min(_RETRY_WAIT_SLICE, remaining)
            await asyncio.sleep(step)
            remaining -= step

    @classmethod
    async def _execute_async_request(cls, method: str, endpoint: str, **kwargs) -> Dict:
        """Business request executor with a retry mechanism.

        Constraint: the client is built only once for the whole retry process and closed by ``async with`` at the end; safe_close does not cancel attempts already started, it only interrupts the retry wait (raising ManageApiShutdownError).
        """
        client = cls._build_client()
        async with client:
            retry_count = 0

            while retry_count <= cls.max_retries:
                try:
                    # Perform the async request
                    return await cls._async_request(client, method, endpoint, **kwargs)
                except Exception as e:
                    # Decide whether to retry
                    if retry_count < cls.max_retries and cls._should_retry(e):
                        retry_count += 1
                        print(
                            f"{method} {endpoint} async request failed, retry #{retry_count} in {cls.retry_delay:.1f} seconds"
                        )
                        await cls._retry_wait()
                        if cls._closed:
                            # The wrap-up must be distinguishable: a bare raise would disguise the shutdown early exit
                            # as network jitter, hiding the service shutdown signal
                            raise ManageApiShutdownError(
                                f"safe_close interrupted the retry wait: {e}") from e
                        continue
                    else:
                        # Do not retry; raise the exception directly
                        raise

    @classmethod
    def _get_instance(cls) -> Optional["ManageApiClient"]:
        """Get the singleton instance reference in a thread-safe way.

        Constraint: the caller must hold the returned local reference; re-reading _instance after a None check is forbidden (TOCTOU window).
        """
        with cls._instance_lock:
            return cls._instance

    @classmethod
    def safe_close(cls):
        """Close the request entry point; in-flight requests release their clients in their own event loops.

        Requests already started are not cancelled; retry waits are interrupted and remaining retries skipped (see _retry_wait).
        """
        with cls._instance_lock:
            cls._closed = True
            cls._instance = None


def api_guard(error_msg: str = None, raise_when_closed: bool = False):
    """Decorator: unified singleton lookup, None check and exception fallback

    - Obtains a local reference to the instance once via _get_instance() and injects it as the decorated function's
      first argument, eliminating the TOCTOU race window with safe_close();
    - When the instance is uninitialized or closed: raise_when_closed=True raises an explicit exception
      (for startup-path functions), otherwise silently returns None (for daemon-thread paths);
    - When error_msg is not None, request exceptions are caught, logged, and None is returned;
      when it is None the exception is re-raised as-is for the caller to handle.
    """

    def decorator(func):
        @functools.wraps(func)
        async def wrapper(*args, **kwargs):
            instance = ManageApiClient._get_instance()
            if instance is None:
                if raise_when_closed:
                    raise Exception("ManageApiClient is not initialized or is closed")
                return None
            if error_msg is None:
                return await func(instance, *args, **kwargs)
            try:
                return await func(instance, *args, **kwargs)
            except Exception as e:
                # Constraint: httpx / parsing exceptions log the full stack; business exceptions log only the
                # message (the message carries its own context, the stack is high-frequency noise)
                if isinstance(e, (httpx.HTTPError, ValueError)):
                    print(f"{error_msg}: {e}\n{traceback.format_exc()}")
                else:
                    print(f"{error_msg}: {e}")
                return None

        return wrapper

    return decorator


@api_guard(raise_when_closed=True)
async def get_server_config(instance) -> Optional[Dict]:
    """Get the basic server config"""
    return await instance._execute_async_request("POST", "/config/server-base")


@api_guard(raise_when_closed=True)
async def get_agent_models(
    instance, mac_address: str, client_id: str, selected_module: Dict
) -> Optional[Dict]:
    """Get the agent model config"""
    return await instance._execute_async_request(
        "POST",
        "/config/agent-models",
        json={
            "macAddress": mac_address,
            "clientId": client_id,
            "selectedModule": selected_module,
        },
    )


@api_guard("Failed to get replacement words")
async def get_correct_words(instance, mac_address: str) -> Optional[Dict]:
    """Get the agent's replacement words"""
    return await instance._execute_async_request(
        "POST", "/config/correct-words",
        json={"macAddress": mac_address}
    )


@api_guard("Failed to generate and save the chat history summary")
async def generate_and_save_chat_summary(instance, session_id: str) -> Optional[Dict]:
    """Generate and save the chat history summary (called from a daemon thread; silently returns None when the service is closed)"""
    return await instance._execute_async_request(
        "POST",
        f"/agent/chat-summary/{session_id}/save",
    )


@api_guard("Failed to generate and save the chat title")
async def generate_and_save_chat_title(instance, session_id: str) -> Optional[Dict]:
    """Generate and save the chat title (called from a daemon thread; silently returns None when the service is closed)"""
    return await instance._execute_async_request(
        "POST",
        f"/agent/chat-title/{session_id}/generate",
    )


@api_guard("TTS report failed")
async def report(
    instance, mac_address: str, session_id: str, chat_type: int, content: str, audio, report_time
) -> Optional[Dict]:
    """Report chat history asynchronously"""
    if not content:
        return None
    return await instance._execute_async_request(
        "POST",
        f"/agent/chat-history/report",
        json={
            "macAddress": mac_address,
            "sessionId": session_id,
            "chatType": chat_type,
            "content": content,
            "reportTime": report_time,
            "audioBase64": (
                base64.b64encode(audio).decode("utf-8") if audio else None
            ),
        },
    )


@api_guard("Contact lookup failed")
async def lookup_address_book(instance, caller_mac: str, nickname: str) -> Optional[Dict]:
    """Look up the target device by nickname"""
    return await instance._execute_async_request(
        "GET",
        f"/device/address-book/lookup?callerMac={caller_mac}&nickname={nickname}",
    )


def init_service(config):
    ManageApiClient(config)


def manage_api_http_safe_close():
    ManageApiClient.safe_close()
