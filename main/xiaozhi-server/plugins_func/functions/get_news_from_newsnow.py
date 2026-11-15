import random
import httpx
from io import BytesIO
from urllib.parse import quote, urlsplit, urlunsplit, parse_qsl
from markitdown import MarkItDown, StreamInfo
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler


TAG = __name__
logger = setup_logging()

CHANNEL_MAP = {
    "V2EX": "v2ex-share",
    "知乎": "zhihu",
    "微博": "weibo",
    "联合早报": "zaobao",
    "酷安": "coolapk",
    "MKTNews": "mktnews-flash",
    "华尔街见闻": "wallstreetcn-quick",
    "36氪": "36kr-quick",
    "抖音": "douyin",
    "虎扑": "hupu",
    "百度贴吧": "tieba",
    "今日头条": "toutiao",
    "IT之家": "ithome",
    "澎湃新闻": "thepaper",
    "卫星通讯社": "sputniknewscn",
    "参考消息": "cankaoxiaoxi",
    "远景论坛": "pcbeta-windows11",
    "财联社": "cls-depth",
    "雪球": "xueqiu-hotstock",
    "格隆汇": "gelonghui",
    "法布财经": "fastbull-express",
    "Solidot": "solidot",
    "Hacker News": "hackernews",
    "Product Hunt": "producthunt",
    "Github": "github-trending-today",
    "哔哩哔哩": "bilibili-hot-search",
    "快手": "kuaishou",
    "靠谱新闻": "kaopu",
    "金十数据": "jin10",
    "百度热搜": "baidu",
    "牛客": "nowcoder",
    "少数派": "sspai",
    "稀土掘金": "juejin",
    "凤凰网": "ifeng",
    "虫部落": "chongbuluo-latest",
}

# Default news sources, used when none are specified in the configuration
DEFAULT_NEWS_SOURCES = "澎湃新闻;百度热搜;财联社"

DEFAULT_NEWS_API_URL = "https://newsnow.busiyi.world/api/s?id="


def _build_news_api_url(source, configured_url=None):
    """Build the request URL and query parameters for the news API.

    If the configured URL has a {source} placeholder, replace it; otherwise set id to the news source id,
    so that a malformed string is not produced even when the config already contains an id.
    """
    api_url = str(configured_url).strip() if configured_url else DEFAULT_NEWS_API_URL
    if "{source}" in api_url:
        return api_url.replace("{source}", quote(source, safe="")), None
    parts = urlsplit(api_url)
    query = dict(parse_qsl(parts.query, keep_blank_values=True))
    query["id"] = source
    return (
        urlunsplit((parts.scheme, parts.netloc, parts.path, "", parts.fragment)),
        query,
    )


def _get_newsnow_config(conn):
    # Get it from the connection configuration
    plugins = conn.config.get("plugins", {})
    newsnow = plugins.get("get_news_from_newsnow", {})
    sources = newsnow.get("news_sources", "")
    if isinstance(sources, str) and sources.strip():
        return sources
    if isinstance(sources, (list, tuple)):
        return ";".join(str(item).strip() for item in sources if str(item).strip())

    return ""

def get_news_sources_from_config(conn):
    """Get the news source string from the configuration"""
    try:
        result = _get_newsnow_config(conn)
        if result:
            logger.bind(tag=TAG).debug(f"Using configured news sources: {result}")
            return result

        logger.bind(tag=TAG).debug("No news source configuration found; using the default")
        return DEFAULT_NEWS_SOURCES

    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to get news source configuration: {e}; using the default")
        return DEFAULT_NEWS_SOURCES


# Get the available news source names from the default config (fetched dynamically at runtime by get_news_sources_from_config)
example_sources_str = DEFAULT_NEWS_SOURCES.replace(";",", ")

GET_NEWS_FROM_NEWSNOW_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_news_from_newsnow",
        "description": "Called when the user asks to read or listen to news (e.g. 'give me some news', 'what is in the news today').",
        "parameters": {
            "type": "object",
            "properties": {
                "source": {
                    "type": "string",
                    "description": f"Standard Chinese name of the news source, e.g. {example_sources_str}. Optional; if not provided, the default news source is used",
                },
                "detail": {
                    "type": "boolean",
                    "description": "Whether to fetch the detailed content; false by default. If true, fetch the detailed content of the previous news item",
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


async def fetch_news_from_api(conn: "ConnectionHandler", source="thepaper"):
    """Fetch the news list from the API"""
    try:
        news_config = conn.config.get("plugins", {}).get("get_news_from_newsnow", {})
        configured_url = news_config.get("url") if isinstance(news_config, dict) else None
        api_url, request_params = _build_news_api_url(source, configured_url)

        headers = {"User-Agent": "Mozilla/5.0"}
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(api_url, params=request_params, headers=headers)

        if response.status_code != 200:
            logger.bind(tag=TAG).error(
                f"News API request failed: HTTP {response.status_code}, source={source}"
            )
            return []
        data = response.json()

        items = data.get("items") if isinstance(data, dict) else None
        if not isinstance(items, list):
            logger.bind(tag=TAG).error(f"Malformed news API response: {data}")
            return []
        return [item for item in items if isinstance(item, dict) and item.get("title")]

    except Exception as e:
        logger.bind(tag=TAG).error(f"News API request failed: {e}")
        return []


async def fetch_news_detail(url):
    """Fetch the news detail page content and clean the HTML with MarkItDown"""
    try:
        headers = {"User-Agent": "Mozilla/5.0"}
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(url, headers=headers)

        # Clean the HTML content with MarkItDown
        md = MarkItDown(enable_plugins=False)
        result = md.convert_stream(
            BytesIO(response.content),
            stream_info=StreamInfo(
                mimetype="text/html",
                extension=".html",
                charset=response.encoding or "utf-8",
            ),
        )

        # Get the cleaned text content
        clean_text = result.text_content

        # If the cleaned content is empty, return a notice
        if not clean_text or len(clean_text.strip()) == 0:
            logger.bind(tag=TAG).warning(f"Cleaned news content is empty: {url}")
            return "Unable to parse the news detail content. The site structure may be unusual or the content may be restricted."

        return clean_text
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch news details: {e}")
        return "Unable to fetch detailed content"


@register_function(
    "get_news_from_newsnow",
    GET_NEWS_FROM_NEWSNOW_FUNCTION_DESC,
    ToolType.SYSTEM_CTL,
)
async def get_news_from_newsnow(
    conn: "ConnectionHandler",
    source: str = "澎湃新闻",
    detail: bool = False,
    lang: str = "zh_CN",
):
    """Fetch news and pick one at random to report, or fetch the detailed content of the previous news item"""
    try:
        # Get the currently configured news sources
        news_sources = get_news_sources_from_config(conn)

        # If detail is True, fetch the detailed content of the previous news item
        detail = str(detail).lower() == "true"
        if detail:
            if (
                not hasattr(conn, "last_newsnow_link")
                or not conn.last_newsnow_link
                or "url" not in conn.last_newsnow_link
            ):
                return ActionResponse(
                    Action.REQLLM,
                    "Sorry, no recently queried news was found. Please fetch a news item first.",
                    None,
                )

            url = conn.last_newsnow_link.get("url")
            title = conn.last_newsnow_link.get("title", "Unknown title")
            source_id = conn.last_newsnow_link.get("source_id", "thepaper")
            source_name = CHANNEL_MAP.get(source_id, "Unknown source")

            if not url or url == "#":
                return ActionResponse(
                    Action.REQLLM, "Sorry, this news item has no usable link for fetching detailed content.", None
                )

            logger.bind(tag=TAG).debug(
                f"Fetching news details: {title}, source: {source_name}, URL={url}"
            )

            # Fetch the news details
            detail_content = await fetch_news_detail(url)

            if not detail_content or detail_content == "Unable to fetch detailed content":
                return ActionResponse(
                    Action.REQLLM,
                    f"Sorry, unable to fetch the detailed content of '{title}'. The link may have expired or the site structure may have changed.",
                    None,
                )

            # Build the detail report
            detail_report = (
                f"Based on the data below, respond in {lang} to the user's news detail query:\n\n"
                f"News title: {title}\n"
                # f"News source: {source_name}\n"
                f"Detailed content: {detail_content}\n\n"
                f"(Summarize the news content above, extract the key information, and report it to the user in a natural, fluent way; "
                f"do not mention that this is a summary, just tell it as a complete news item)"
            )

            return ActionResponse(Action.REQLLM, detail_report, None)

        # Otherwise, fetch the news list and pick one at random
        # Convert the Chinese name to the English ID
        english_source_id = None

        # Check whether the given Chinese name is among the configured news sources
        news_sources_list = [name.strip() for name in news_sources.split(";") if name.strip()]
        if source in news_sources_list:
            english_source_id = CHANNEL_MAP.get(source)
        elif not source and news_sources_list:
            source = news_sources_list[0]
            english_source_id = CHANNEL_MAP.get(source)

        # If no matching English ID is found, use the default source
        if not english_source_id:
            fallback_source = next(
                (name for name in news_sources_list if CHANNEL_MAP.get(name)),
                "澎湃新闻",
            )
            logger.bind(tag=TAG).warning(
                f"Invalid news source: {source}; using the default source from the configuration: {fallback_source}"
            )
            english_source_id = CHANNEL_MAP[fallback_source]
            source = fallback_source

        logger.bind(tag=TAG).info(f"Fetching news: source={source}({english_source_id})")

        # Fetch the news list
        news_items = await fetch_news_from_api(conn, english_source_id)

        if not news_items:
            return ActionResponse(
                Action.REQLLM,
                f"Sorry, failed to fetch news from {source}. Please try again later or try another news source.",
                None,
            )

        # Pick a news item at random
        selected_news = random.choice(news_items)
        title = selected_news.get("title", "Unknown title")

        # Save the current news link on the connection object for later detail queries
        if not hasattr(conn, "last_newsnow_link"):
            conn.last_newsnow_link = {}
        conn.last_newsnow_link = {
            "url": selected_news.get("url", "#"),
            "title": title,
            "source_id": english_source_id,
        }

        # Build the news report
        news_report = (
            f"Based on the data below, respond in {lang} to the user's news query:\n\n"
            f"News title: {title}\n"
            # f"News source: {source}\n"
            f"(Report this news headline to the user in a natural, fluent way, "
            f"and let the user know they can ask for the detailed content, in which case the news details will be fetched.)"
        )

        return ActionResponse(Action.REQLLM, news_report, None)

    except Exception as e:
        logger.bind(tag=TAG).error(f"Error fetching news: {e}")
        return ActionResponse(
            Action.REQLLM, "Sorry, an error occurred while fetching news. Please try again later.", None
        )
