from datetime import datetime
import cnlunar
from plugins_func.register import register_function, ToolType, ActionResponse, Action

get_lunar_function_desc = {
    "type": "function",
    "function": {
        "name": "get_lunar",
        "description": (
            "Provides lunar calendar and Chinese almanac information for a specific date. "
            "The user can specify what to query, such as: lunar date, heavenly stems and earthly branches, solar terms, zodiac, constellation, eight characters (Bazi), suitable and unsuitable activities, etc. "
            "If nothing is specified, the Ganzhi year and the lunar date are queried by default. "
            "For basic queries such as 'what is the lunar date today' or 'the lunar date today', use the information in context directly and do not call this tool."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "date": {
                    "type": "string",
                    "description": "The date to query, in YYYY-MM-DD format, e.g. 2024-01-01. If not provided, the current date is used",
                },
                "query": {
                    "type": "string",
                    "description": "What to query, e.g. lunar date, heavenly stems and earthly branches, holidays, solar terms, zodiac, constellation, eight characters (Bazi), suitable and unsuitable activities, etc.",
                },
            },
            "required": [],
        },
    },
}


@register_function("get_lunar", get_lunar_function_desc, ToolType.WAIT)
def get_lunar(date=None, query=None):
    """
    Get the current lunar date and almanac information such as heavenly stems and earthly branches, solar terms, zodiac, constellation, eight characters, and suitable/unsuitable activities
    """
    from core.utils.cache.manager import cache_manager, CacheType

    # If a date parameter is provided, use that date; otherwise use the current date
    if date:
        try:
            now = datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            return ActionResponse(
                Action.REQLLM,
                f"Invalid date format, please use the YYYY-MM-DD format, for example: 2024-01-01",
                None,
            )
    else:
        now = datetime.now()

    current_date = now.strftime("%Y-%m-%d")

    # If query is None, use the default text
    if query is None:
        query = "the Ganzhi year and the lunar date (default query)"

    # Try to get the lunar info from the cache
    lunar_cache_key = f"lunar_info_{current_date}"
    cached_lunar_info = cache_manager.get(CacheType.LUNAR, lunar_cache_key)
    if cached_lunar_info:
        return ActionResponse(Action.REQLLM, cached_lunar_info, None)

    response_text = f"Respond to the user's query based on the following information, and provide information related to {query}:\n"

    lunar = cnlunar.Lunar(now, godType="8char")
    response_text += (
        "Lunar calendar information:\n"
        "%s年%s%s\n" % (lunar.lunarYearCn, lunar.lunarMonthCn[:-1], lunar.lunarDayCn)
        + "Stems and branches (Ganzhi): %s year, %s month, %s day\n" % (lunar.year8Char, lunar.month8Char, lunar.day8Char)
        + "Zodiac: %s\n" % (lunar.chineseYearZodiac)
        + "Eight characters (Bazi): %s\n"
        % (
            " ".join(
                [lunar.year8Char, lunar.month8Char, lunar.day8Char, lunar.twohour8Char]
            )
        )
        + "Holidays today: %s\n"
        % (
            ",".join(
                filter(
                    None,
                    (
                        lunar.get_legalHolidays(),
                        lunar.get_otherHolidays(),
                        lunar.get_otherLunarHolidays(),
                    ),
                )
            )
        )
        + "Solar term today: %s\n" % (lunar.todaySolarTerms)
        + "Next solar term: %s %s-%s-%s\n"
        % (
            lunar.nextSolarTerm,
            lunar.nextSolarTermYear,
            lunar.nextSolarTermDate[0],
            lunar.nextSolarTermDate[1],
        )
        + "Solar terms this year: %s\n"
        % (
            ", ".join(
                [
                    f"{term}({date[0]}/{date[1]})"
                    for term, date in lunar.thisYearSolarTermsDic.items()
                ]
            )
        )
        + "Zodiac clash: %s\n" % (lunar.chineseZodiacClash)
        + "Constellation: %s\n" % (lunar.starZodiac)
        + "Nayin: %s\n" % lunar.get_nayin()
        + "Pengzu taboos: %s\n" % (lunar.get_pengTaboo(delimit=", "))
        + "Day officer: %s\n" % lunar.get_today12DayOfficer()[0]
        + "Day deity: %s(%s)\n"
        % (lunar.get_today12DayOfficer()[1], lunar.get_today12DayOfficer()[2])
        + "Twenty-eight mansions: %s\n" % lunar.get_the28Stars()
        + "Auspicious deity directions: %s\n" % " ".join(lunar.get_luckyGodsDirection())
        + "Fetal god today: %s\n" % lunar.get_fetalGod()
        + "Suitable: %s\n" % ", ".join(lunar.goodThing[:10])
        + "Avoid: %s\n" % ", ".join(lunar.badThing[:10])
        + "(By default return the Ganzhi year and the lunar date; return the suitable/avoid items for the day only when they are asked for)"
    )

    # Cache the lunar info
    cache_manager.set(CacheType.LUNAR, lunar_cache_key, response_text)

    return ActionResponse(Action.REQLLM, response_text, None)
