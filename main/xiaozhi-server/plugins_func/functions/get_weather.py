import asyncio
import httpx
from bs4 import BeautifulSoup
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from core.utils.util import get_ip_info
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler

TAG = __name__
logger = setup_logging()

GET_WEATHER_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": (
            "Get the weather for a location. The user should provide a location; for example, if the user says Hangzhou weather, the parameter is: Hangzhou. "
            "If the user names a province, use its capital city by default. If the user names a place that is neither a province nor a city, use the capital city of the province where that place is located by default. "
            "Important: the local 7-day weather forecast is already provided in the context; never call this tool unless the user specifies another city."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "Location name, e.g. Hangzhou. Optional; omit it if not provided",
                },
                "lang": {
                    "type": "string",
                    "description": "Language code used by the user, e.g. zh_CN/zh_HK/en_US/ja_JP; zh_CN by default",
                },
            },
            "required": ["lang"],
        },
    },
}

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36"
    )
}

# Weather codes https://dev.qweather.com/docs/resource/icons/#weather-icons
WEATHER_CODE_MAP = {
    "100": "晴",
    "101": "多云",
    "102": "少云",
    "103": "晴间多云",
    "104": "阴",
    "150": "晴",
    "151": "多云",
    "152": "少云",
    "153": "晴间多云",
    "300": "阵雨",
    "301": "强阵雨",
    "302": "雷阵雨",
    "303": "强雷阵雨",
    "304": "雷阵雨伴有冰雹",
    "305": "小雨",
    "306": "中雨",
    "307": "大雨",
    "308": "极端降雨",
    "309": "毛毛雨/细雨",
    "310": "暴雨",
    "311": "大暴雨",
    "312": "特大暴雨",
    "313": "冻雨",
    "314": "小到中雨",
    "315": "中到大雨",
    "316": "大到暴雨",
    "317": "暴雨到大暴雨",
    "318": "大暴雨到特大暴雨",
    "350": "阵雨",
    "351": "强阵雨",
    "399": "雨",
    "400": "小雪",
    "401": "中雪",
    "402": "大雪",
    "403": "暴雪",
    "404": "雨夹雪",
    "405": "雨雪天气",
    "406": "阵雨夹雪",
    "407": "阵雪",
    "408": "小到中雪",
    "409": "中到大雪",
    "410": "大到暴雪",
    "456": "阵雨夹雪",
    "457": "阵雪",
    "499": "雪",
    "500": "薄雾",
    "501": "雾",
    "502": "霾",
    "503": "扬沙",
    "504": "浮尘",
    "507": "沙尘暴",
    "508": "强沙尘暴",
    "509": "浓雾",
    "510": "强浓雾",
    "511": "中度霾",
    "512": "重度霾",
    "513": "严重霾",
    "514": "大雾",
    "515": "特强浓雾",
    "900": "热",
    "901": "冷",
    "999": "未知",
}


async def fetch_city_info(location, api_key, api_host):
    url = f"https://{api_host}/geo/v2/city/lookup"
    async with httpx.AsyncClient(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
        response = await client.get(
            url,
            params={
                "key": api_key,
                "location": location,
                "lang": "zh",
                "number": 1,
            },
            headers=HEADERS,
        )
    try:
        data = response.json()
    except ValueError:
        logger.bind(tag=TAG).error(
            f"Failed to look up weather city: HTTP {response.status_code} returned non-JSON content"
        )
        return None
    if not isinstance(data, dict):
        logger.bind(tag=TAG).error("Failed to look up weather city: the response is not a JSON object")
        return None
    if response.status_code != 200 or data.get("code") != "200":
        logger.bind(tag=TAG).error(
            f"Failed to look up weather city: HTTP {response.status_code}, code {data.get('code')}"
        )
        return None
    return data.get("location", [])[0] if data.get("location") else None


async def fetch_weather_data(city_info, api_key, api_host):
    location_id = city_info.get("id")
    if not location_id:
        return None

    base_url = f"https://{api_host}/v7/weather"
    params = {"key": api_key, "location": location_id, "lang": "zh"}

    async def request(client, endpoint):
        response = await client.get(f"{base_url}/{endpoint}", params=params, headers=HEADERS)
        try:
            data = response.json()
        except ValueError:
            return None
        if response.status_code != 200 or data.get("code") != "200":
            logger.bind(tag=TAG).error(
                f"Failed to fetch weather data: endpoint={endpoint} HTTP {response.status_code}, code {data.get('code')}"
            )
            return None
        return data

    try:
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            now, daily = await asyncio.gather(
                request(client, "now"), request(client, "7d")
            )
    except Exception as e:
        logger.bind(tag=TAG).warning(f"Weather JSON API failed; will try the web page: {e}")
        return None
    if now is None or daily is None:
        return None
    return now, daily


def build_weather_report(city_info, now_data, daily_data):
    city_name = city_info.get("name") or city_info.get("adm2") or "Unknown location"
    now = now_data.get("now", {})
    weather_report = f"The location you queried is: {city_name}\n\n"
    weather_report += f"Current weather: {now.get('text', 'Unknown')}\n"

    current_basic = {
        "Temperature": f"{now['temp']}℃" if now.get("temp") is not None else None,
        "Feels like": f"{now['feelsLike']}℃" if now.get("feelsLike") is not None else None,
        "Humidity": f"{now['humidity']}%" if now.get("humidity") is not None else None,
        "Wind direction": now.get("windDir"),
        "Wind scale": now.get("windScale"),
        "Visibility": f"{now['vis']} km" if now.get("vis") is not None else None,
        "Pressure": f"{now['pressure']} hPa" if now.get("pressure") is not None else None,
        "Precipitation": f"{now['precip']} mm" if now.get("precip") is not None else None,
    }
    current_basic = {key: value for key, value in current_basic.items() if value}
    if current_basic:
        weather_report += "Detailed parameters:\n"
        weather_report += "".join(f"  · {key}: {value}\n" for key, value in current_basic.items())

    weather_report += "\n7-day forecast:\n"
    for item in daily_data.get("daily", [])[:7]:
        date = item.get("fxDate", "Unknown date")
        weather = item.get("textDay") or WEATHER_CODE_MAP.get(item.get("iconDay"), "Unknown")
        high = item.get("tempMax", "Unknown")
        low = item.get("tempMin", "Unknown")
        weather_report += f"{date}: {weather}, temperature {low}~{high}℃\n"
    weather_report += "\n(If you need the detailed weather for a specific day, please tell me the date)"
    return weather_report


async def fetch_weather_page(url):
    async with httpx.AsyncClient(
        timeout=httpx.Timeout(10.0, connect=3.0), follow_redirects=True
    ) as client:
        response = await client.get(url, headers=HEADERS)
    return BeautifulSoup(response.text, "html.parser") if response.status_code == 200 else None


def parse_weather_info(soup):
    city_name = soup.select_one("h1.c-submenu__location").get_text(strip=True)

    current_abstract = soup.select_one(".c-city-weather-current .current-abstract")
    current_abstract = (
        current_abstract.get_text(strip=True) if current_abstract else "Unknown"
    )

    current_basic = {}
    for item in soup.select(
        ".c-city-weather-current .current-basic .current-basic___item"
    ):
        parts = item.get_text(strip=True, separator=" ").split(" ")
        if len(parts) == 2:
            key, value = parts[1], parts[0]
            current_basic[key] = value

    temps_list = []
    for row in soup.select(".city-forecast-tabs__row")[:7]:  # Take the first 7 days of data
        date = row.select_one(".date-bg .date").get_text(strip=True)
        weather_code = (
            row.select_one(".date-bg .icon")["src"].split("/")[-1].split(".")[0]
        )
        weather = WEATHER_CODE_MAP.get(weather_code, "Unknown")
        temps = [span.get_text(strip=True) for span in row.select(".tmp-cont .temp")]
        high_temp, low_temp = (temps[0], temps[-1]) if len(temps) >= 2 else (None, None)
        temps_list.append((date, weather, high_temp, low_temp))

    return city_name, current_abstract, current_basic, temps_list


@register_function("get_weather", GET_WEATHER_FUNCTION_DESC, ToolType.SYSTEM_CTL)
async def get_weather(conn: "ConnectionHandler", location: str = None, lang: str = "zh_CN"):
    from core.utils.cache.manager import cache_manager, CacheType

    weather_config = conn.config.get("plugins", {}).get("get_weather", {})
    api_host = weather_config.get("api_host", "mj7p3y7naa.re.qweatherapi.com")
    api_key = weather_config.get("api_key", "a861d0d5e7bf4ee1a83d9a9e4f96d4da")
    default_location = weather_config.get("default_location", "广州")
    client_ip = conn.client_ip

    # Prefer the location parameter provided by the user
    if not location:
        # Resolve the city from the client IP
        if client_ip:
            # First get the city info for the IP from the cache
            cached_ip_info = cache_manager.get(CacheType.IP_INFO, client_ip)
            if cached_ip_info:
                location = cached_ip_info.get("city")
            else:
                # Cache miss; call the API to get it
                # get_ip_info is a synchronous requests call; run it in the thread pool to avoid blocking the main event loop
                ip_info = await asyncio.to_thread(get_ip_info, client_ip, logger)
                if ip_info:
                    cache_manager.set(CacheType.IP_INFO, client_ip, ip_info)
                    location = ip_info.get("city")

            if not location:
                location = default_location
        else:
            # If there is no IP, use the default location
            location = default_location
    # Try to get the full weather report from the cache
    weather_cache_key = f"full_weather_{location}_{lang}"
    cached_weather_report = cache_manager.get(CacheType.WEATHER, weather_cache_key)
    if cached_weather_report:
        return ActionResponse(Action.REQLLM, cached_weather_report, None)

    # Cache miss; fetch live weather data
    city_info = await fetch_city_info(location, api_key, api_host)
    if not city_info:
        return ActionResponse(
            Action.REQLLM,
            f"The weather for {location} is temporarily unavailable (city not found or weather service unavailable), please try again later",
            None,
        )
    weather_data = await fetch_weather_data(city_info, api_key, api_host)
    if weather_data:
        weather_report = build_weather_report(city_info, *weather_data)
    else:
        fx_link = city_info.get("fxLink")
        soup = await fetch_weather_page(fx_link) if fx_link else None
        if not soup:
            return ActionResponse(Action.REQLLM, None, "Failed to request weather data")
        city_name, current_abstract, current_basic, temps_list = parse_weather_info(soup)
        weather_report = f"The location you queried is: {city_name}\n\nCurrent weather: {current_abstract}\n"
        if current_basic:
            weather_report += "Detailed parameters:\n"
            weather_report += "".join(
                f"  · {key}: {value}\n" for key, value in current_basic.items() if value != "0"
            )
        weather_report += "\n7-day forecast:\n"
        weather_report += "".join(
            f"{date}: {weather}, temperature {low}~{high}\n"
            for date, weather, high, low in temps_list
        )
        weather_report += "\n(If you need the detailed weather for a specific day, please tell me the date)"

    # Cache the full weather report
    cache_manager.set(CacheType.WEATHER, weather_cache_key, weather_report)

    return ActionResponse(Action.REQLLM, weather_report, None)
