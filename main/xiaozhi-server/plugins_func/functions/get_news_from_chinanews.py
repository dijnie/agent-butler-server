import random
import httpx
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
from config.logger import setup_logging
from plugins_func.register import register_function, ToolType, ActionResponse, Action
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from core.connection import ConnectionHandler


TAG = __name__
logger = setup_logging()

GET_NEWS_FROM_CHINANEWS_FUNCTION_DESC = {
    "type": "function",
    "function": {
        "name": "get_news_from_chinanews",
        "description": (
            "Called when the user asks to read or listen to news (e.g. 'give me some news', 'what is in the news today'). "
            "The user can specify a news type, such as society news, technology news, or international news. "
            "If none is specified, society news is reported by default."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "category": {
                    "type": "string",
                    "description": "News category, e.g. 社会 (society), 科技 (technology), 国际 (international). Optional; if not provided, the default category is used",
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


async def fetch_news_from_rss(rss_url):
    """Fetch the news list from the RSS feed"""
    try:
        async with httpx.AsyncClient(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
            response = await client.get(rss_url)

        # Parse the XML
        root = ET.fromstring(response.content)

        # Find all item elements (news entries)
        news_items = []
        for item in root.findall(".//item"):
            title = (
                item.find("title").text if item.find("title") is not None else "Untitled"
            )
            link = item.find("link").text if item.find("link") is not None else "#"
            description = (
                item.find("description").text
                if item.find("description") is not None
                else "No description"
            )
            pubDate = (
                item.find("pubDate").text
                if item.find("pubDate") is not None
                else "Unknown time"
            )

            news_items.append(
                {
                    "title": title,
                    "link": link,
                    "description": description,
                    "pubDate": pubDate,
                }
            )

        return news_items
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch RSS news: {e}")
        return []


async def fetch_news_detail(url):
    """Fetch the news detail page content and summarize it"""
    try:
        async with httpx.AsyncClient(timeout=httpx.Timeout(10.0, connect=3.0)) as client:
            response = await client.get(url)

        soup = BeautifulSoup(response.content, "html.parser")

        # Try to extract the article body (the selectors here need to be adjusted to the actual site structure)
        content_div = soup.select_one(
            ".content_desc, .content, article, .article-content"
        )
        if content_div:
            paragraphs = content_div.find_all("p")
            content = "\n".join(
                [p.get_text().strip() for p in paragraphs if p.get_text().strip()]
            )
            return content
        else:
            # If no specific content area is found, try to get all paragraphs
            paragraphs = soup.find_all("p")
            content = "\n".join(
                [p.get_text().strip() for p in paragraphs if p.get_text().strip()]
            )
            return content[:2000]  # Limit the length
    except Exception as e:
        logger.bind(tag=TAG).error(f"Failed to fetch news details: {e}")
        return "Unable to fetch detailed content"


def map_category(category_text):
    """Map the Chinese category entered by the user to the category key in the config file"""
    if not category_text:
        return None

    # Category mapping dict; currently supports society, international, and finance news. For more types, see the config file
    category_map = {
        # Society news
        "社会": "society_rss_url",
        "社会新闻": "society_rss_url",
        # International news
        "国际": "world_rss_url",
        "国际新闻": "world_rss_url",
        # Finance news
        "财经": "finance_rss_url",
        "财经新闻": "finance_rss_url",
        "金融": "finance_rss_url",
        "经济": "finance_rss_url",
    }

    # Convert to lowercase and strip whitespace
    normalized_category = category_text.lower().strip()

    # Return the mapped result, or the original input if there is no match
    return category_map.get(normalized_category, category_text)


@register_function(
    "get_news_from_chinanews",
    GET_NEWS_FROM_CHINANEWS_FUNCTION_DESC,
    ToolType.SYSTEM_CTL,
)
async def get_news_from_chinanews(
    conn: "ConnectionHandler",
    category: str = None,
    detail: bool = False,
    lang: str = "zh_CN",
):
    """Fetch news and pick one at random to report, or fetch the detailed content of the previous news item"""
    try:
        # If detail is True, fetch the detailed content of the previous news item
        if detail:
            if (
                not hasattr(conn, "last_news_link")
                or not conn.last_news_link
                or "link" not in conn.last_news_link
            ):
                return ActionResponse(
                    Action.REQLLM,
                    "Sorry, no recently queried news was found. Please fetch a news item first.",
                    None,
                )

            link = conn.last_news_link.get("link")
            title = conn.last_news_link.get("title", "Unknown title")

            if link == "#":
                return ActionResponse(
                    Action.REQLLM, "Sorry, this news item has no usable link for fetching detailed content.", None
                )

            logger.bind(tag=TAG).debug(f"Fetching news details: {title}, URL={link}")

            # Fetch the news details
            detail_content = await fetch_news_detail(link)

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
                f"Detailed content: {detail_content}\n\n"
                f"(Summarize the news content above, extract the key information, and report it to the user in a natural, fluent way; "
                f"do not mention that this is a summary, just tell it as a complete news story)"
            )

            return ActionResponse(Action.REQLLM, detail_report, None)

        # Otherwise, fetch the news list and pick one at random
        # Get the RSS URL from the configuration
        rss_config = conn.config.get("plugins", {}).get("get_news_from_chinanews", {})
        default_rss_url = rss_config.get(
            "default_rss_url", "https://www.chinanews.com.cn/rss/society.xml"
        )

        # Map the user-entered category to the category key in the configuration
        mapped_category = map_category(category)

        # If a category was provided, try to get the corresponding URL from the configuration
        rss_url = default_rss_url
        if mapped_category and mapped_category in rss_config:
            rss_url = rss_config[mapped_category]

        logger.bind(tag=TAG).info(
            f"Fetching news: original category={category}, mapped category={mapped_category}, URL={rss_url}"
        )

        # Fetch the news list
        news_items = await fetch_news_from_rss(rss_url)

        if not news_items:
            return ActionResponse(
                Action.REQLLM, "Sorry, failed to fetch news. Please try again later.", None
            )

        # Pick a news item at random
        selected_news = random.choice(news_items)

        # Save the current news link on the connection object for later detail queries
        if not hasattr(conn, "last_news_link"):
            conn.last_news_link = {}
        conn.last_news_link = {
            "link": selected_news.get("link", "#"),
            "title": selected_news.get("title", "Unknown title"),
        }

        # Build the news report
        news_report = (
            f"Based on the data below, respond in {lang} to the user's news query:\n\n"
            f"News title: {selected_news['title']}\n"
            f"Published at: {selected_news['pubDate']}\n"
            f"News content: {selected_news['description']}\n"
            f"(Report this news item to the user in a natural, fluent way; you may summarize the content as appropriate. "
            f"Just read out the news, without any extra content. "
            f"If the user asks for more details, tell the user they can say 'please tell me more about this news' to get more)"
        )

        return ActionResponse(Action.REQLLM, news_report, None)

    except Exception as e:
        logger.bind(tag=TAG).error(f"Error fetching news: {e}")
        return ActionResponse(
            Action.REQLLM, "Sorry, an error occurred while fetching news. Please try again later.", None
        )
