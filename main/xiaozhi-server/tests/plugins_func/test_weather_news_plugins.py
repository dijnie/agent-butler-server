"""Tests for the weather and newsnow plugin helpers.

The two plugins talk to external APIs, so the HTTP layer is replaced with a
fake client and every request is recorded. Nothing here touches the network.
"""
import httpx
import pytest

from plugins_func.functions import get_news_from_newsnow as news_module
from plugins_func.functions import get_weather as weather_module


class FakeResponse:
    def __init__(self, status_code=200, payload=None, text="", json_error=None):
        self.status_code = status_code
        self.payload = payload
        self.text = text
        self.json_error = json_error

    def json(self):
        if self.json_error is not None:
            raise self.json_error
        return self.payload


class FakeAsyncClient:
    """Stands in for httpx.AsyncClient and records what was requested."""

    requests = []
    responder = None
    init_kwargs = {}

    def __init__(self, *args, **kwargs):
        FakeAsyncClient.init_kwargs = kwargs

    async def __aenter__(self):
        return self

    async def __aexit__(self, *exc_info):
        return False

    async def get(self, url, params=None, headers=None):
        FakeAsyncClient.requests.append({"url": url, "params": params})
        return FakeAsyncClient.responder(url, params)


@pytest.fixture
def fake_http(monkeypatch):
    """Replace httpx.AsyncClient with the recording fake."""
    FakeAsyncClient.requests = []
    FakeAsyncClient.responder = lambda url, params: FakeResponse(payload={"code": "200"})
    FakeAsyncClient.init_kwargs = {}
    monkeypatch.setattr(httpx, "AsyncClient", FakeAsyncClient)
    return FakeAsyncClient


class FakeConn:
    def __init__(self, plugins=None):
        self.config = {"plugins": plugins or {}}
        self.client_ip = None


# ---------------------------------------------------------------------------
# City lookup
# ---------------------------------------------------------------------------


async def test_city_lookup_returns_none_on_error_code(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(payload={"code": "402"})

    result = await weather_module.fetch_city_info("杭州", "key", "host")

    assert result is None


async def test_city_lookup_returns_none_on_non_json_body(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(
        text="<html>oops</html>", json_error=ValueError("not json")
    )

    result = await weather_module.fetch_city_info("杭州", "key", "host")

    assert result is None


async def test_city_lookup_returns_none_on_non_dict_body(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(payload=["not", "an", "object"])

    result = await weather_module.fetch_city_info("杭州", "key", "host")

    assert result is None


async def test_city_lookup_returns_none_on_empty_location(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(
        payload={"code": "200", "location": []}
    )

    result = await weather_module.fetch_city_info("杭州", "key", "host")

    assert result is None


async def test_city_lookup_searches_all_cities(fake_http):
    """Without the range parameter the lookup is global; hard-coding cn would miss cities outside China."""
    fake_http.responder = lambda url, params: FakeResponse(
        payload={"code": "200", "location": [{"id": "101210101", "name": "杭州"}]}
    )

    result = await weather_module.fetch_city_info("杭州", "key", "host")

    assert result == {"id": "101210101", "name": "杭州"}
    sent = fake_http.requests[0]["params"]
    assert "range" not in sent
    assert sent["location"] == "杭州"
    assert sent["number"] == 1


# ---------------------------------------------------------------------------
# Weather data
# ---------------------------------------------------------------------------


def _weather_responder(now_payload, daily_payload):
    def responder(url, params):
        if url.endswith("/now"):
            return now_payload if isinstance(now_payload, FakeResponse) else FakeResponse(
                payload=now_payload
            )
        return daily_payload if isinstance(daily_payload, FakeResponse) else FakeResponse(
            payload=daily_payload
        )

    return responder


async def test_weather_data_needs_both_now_and_daily(fake_http):
    fake_http.responder = _weather_responder(
        {"code": "200", "now": {"text": "晴"}},
        FakeResponse(status_code=401, payload={"code": "401"}),
    )

    assert await weather_module.fetch_weather_data({"id": "1"}, "key", "host") is None


async def test_weather_data_needs_daily_when_now_failed(fake_http):
    fake_http.responder = _weather_responder(
        FakeResponse(status_code=401, payload={"code": "401"}),
        {"code": "200", "daily": [{"fxDate": "2026-10-24"}]},
    )

    assert await weather_module.fetch_weather_data({"id": "1"}, "key", "host") is None


async def test_weather_data_returns_both_when_all_succeed(fake_http):
    fake_http.responder = _weather_responder(
        {"code": "200", "now": {"text": "晴"}},
        {"code": "200", "daily": [{"fxDate": "2026-10-24"}]},
    )

    now, daily = await weather_module.fetch_weather_data({"id": "1"}, "key", "host")

    assert now["now"]["text"] == "晴"
    assert daily["daily"][0]["fxDate"] == "2026-10-24"


async def test_weather_page_follows_redirects(fake_http):
    """The old-style fxLink returns a 302; the content cannot be fetched without following redirects."""
    fake_http.responder = lambda url, params: FakeResponse(text="<html></html>")

    await weather_module.fetch_weather_page("https://www.qweather.com/weather/101210101.html")

    assert fake_http.init_kwargs.get("follow_redirects") is True


def test_weather_report_keeps_pressure_and_precipitation():
    report = weather_module.build_weather_report(
        {"name": "杭州"},
        {"now": {"text": "多云", "temp": "24", "pressure": "1003", "precip": "0.0"}},
        {"daily": []},
    )

    assert "Pressure: 1003 hPa" in report
    assert "Precipitation: 0.0 mm" in report


async def test_weather_report_keeps_pressure_and_precipitation_in_flow(monkeypatch):
    """The report must also contain pressure and precipitation when the whole pipeline runs."""
    monkeypatch.setattr(
        weather_module,
        "fetch_city_info",
        _async_value({"id": "1", "name": "杭州"}),
    )
    monkeypatch.setattr(
        weather_module,
        "fetch_weather_data",
        _async_value(
            ({"now": {"text": "多云", "pressure": "1003", "precip": "0.0"}}, {"daily": []})
        ),
    )

    response = await weather_module.get_weather(
        FakeConn({"get_weather": {"api_key": "k", "api_host": "h"}}), location="Pressure Test City"
    )

    assert "Pressure: 1003 hPa" in response.result
    assert "Precipitation: 0.0 mm" in response.result


async def test_missing_fxlink_does_not_call_web_fallback(monkeypatch):
    """When the city info has no fxLink, do not fetch the web page; report failure directly."""
    called = []

    async def fake_city_info(*args, **kwargs):
        return {"id": "1", "name": "杭州"}

    async def fake_weather_data(*args, **kwargs):
        return None

    async def fake_page(url):
        called.append(url)
        return None

    monkeypatch.setattr(weather_module, "fetch_city_info", fake_city_info)
    monkeypatch.setattr(weather_module, "fetch_weather_data", fake_weather_data)
    monkeypatch.setattr(weather_module, "fetch_weather_page", fake_page)

    response = await weather_module.get_weather(
        FakeConn({"get_weather": {"api_key": "k", "api_host": "h"}}), location="No Link City"
    )

    assert called == []
    assert response.response == "Failed to request weather data"


async def test_city_not_found_message_does_not_blame_the_place_name(monkeypatch):
    """An invalid key and a city that cannot be found both end in this sentence; the user must not be told to check the place name."""

    async def fake_city_info(*args, **kwargs):
        return None

    monkeypatch.setattr(weather_module, "fetch_city_info", fake_city_info)

    response = await weather_module.get_weather(
        FakeConn({"get_weather": {"api_key": "k", "api_host": "h"}}), location="Any City"
    )

    assert "Please confirm that the location is correct" not in response.result
    assert "weather service unavailable" in response.result


# ---------------------------------------------------------------------------
# News API
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    "configured_url, expected_url, expected_params",
    [
        (None, "https://newsnow.busiyi.world/api/s", {"id": "thepaper"}),
        (
            "https://newsnow.busiyi.world/api/s?id=thepaper",
            "https://newsnow.busiyi.world/api/s",
            {"id": "thepaper"},
        ),
        (
            "https://newsnow.busiyi.world/api/s?id={source}",
            "https://newsnow.busiyi.world/api/s?id=thepaper",
            None,
        ),
        (
            "https://newsnow.busiyi.world/api/s",
            "https://newsnow.busiyi.world/api/s",
            {"id": "thepaper"},
        ),
        (
            "https://newsnow.busiyi.world/api/s?id=",
            "https://newsnow.busiyi.world/api/s",
            {"id": "thepaper"},
        ),
        (
            "https://newsnow.busiyi.world/api/s?id=thepaper&limit=5",
            "https://newsnow.busiyi.world/api/s",
            {"id": "thepaper", "limit": "5"},
        ),
    ],
)
def test_news_api_url_forms(configured_url, expected_url, expected_params):
    url, params = news_module._build_news_api_url("thepaper", configured_url)

    assert url == expected_url
    assert params == expected_params


async def test_news_api_url_forms_are_actually_requested(fake_http):
    """Even with an id written in the config, no dirty string may be assembled."""
    fake_http.responder = lambda url, params: FakeResponse(
        payload={"items": [{"id": "1", "title": "Title"}]}
    )
    conn = FakeConn({"get_news_from_newsnow": {"url": "https://newsnow.busiyi.world/api/s?id=thepaper"}})

    await news_module.fetch_news_from_api(conn, "thepaper")

    assert fake_http.requests[0]["url"] == "https://newsnow.busiyi.world/api/s"
    assert fake_http.requests[0]["params"] == {"id": "thepaper"}


async def test_news_items_must_be_a_list(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(payload={"items": "oops"})

    assert await news_module.fetch_news_from_api(FakeConn(), "thepaper") == []


async def test_news_items_without_title_are_filtered_out(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(
        payload={"items": [{"id": "1"}, {"id": "2", "title": ""}]}
    )

    assert await news_module.fetch_news_from_api(FakeConn(), "thepaper") == []


async def test_news_items_keep_valid_entries(fake_http):
    fake_http.responder = lambda url, params: FakeResponse(
        payload={"items": [{"id": "1", "title": ""}, {"id": "2", "title": "Valid title"}]}
    )

    items = await news_module.fetch_news_from_api(FakeConn(), "thepaper")

    assert items == [{"id": "2", "title": "Valid title"}]


def _async_value(value):
    async def _inner(*args, **kwargs):
        return value

    return _inner
