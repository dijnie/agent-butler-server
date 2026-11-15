# get_news_from_newsnow Plugin News Source Configuration Guide

## Overview

The `get_news_from_newsnow` plugin now supports configuring news sources dynamically through the web management interface, so no code changes are needed. You can configure different news sources for each agent in the control console.

## Configuration Methods

### 1. Configure through the web management interface (recommended)

1. Log in to the control console
2. Go to the "Role Configuration" page
3. Select the agent you want to configure
4. Click the "Edit Functions" button
5. In the parameter configuration area on the right, find the "NewsNow aggregation" plugin
6. In the news source field (labelled `新闻源配置`, "news source configuration"), enter the semicolon-separated Chinese names

### 2. Configure through the config file

Configure in `config.yaml`:

```yaml
plugins:
  get_news_from_newsnow:
    url: "https://newsnow.busiyi.world/api/s?id="
    news_sources: "澎湃新闻;百度热搜;财联社;微博;抖音"
```

## News Source Configuration Format

News sources are configured as Chinese names separated by semicolons, in this format:

```
Chinese name 1;Chinese name 2;Chinese name 3
```

### Configuration example

```
澎湃新闻;百度热搜;财联社;微博;抖音;知乎;36氪
```

## Supported News Sources

The plugin supports the following news sources (use the Chinese names exactly as written; English glosses are in parentheses):

- 澎湃新闻 (The Paper)
- 百度热搜 (Baidu Hot Search)
- 财联社 (Cailian Press)
- 微博 (Weibo)
- 抖音 (Douyin)
- 知乎 (Zhihu)
- 36氪 (36Kr)
- 华尔街见闻 (Wallstreetcn)
- IT之家 (ITHome)
- 今日头条 (Toutiao)
- 虎扑 (Hupu)
- 哔哩哔哩 (Bilibili)
- 快手 (Kuaishou)
- 雪球 (Xueqiu)
- 格隆汇 (Gelonghui)
- 法布财经 (Fastbull)
- 金十数据 (Jin10)
- 牛客 (Nowcoder)
- 少数派 (sspai)
- 稀土掘金 (Juejin)
- 凤凰网 (Ifeng)
- 虫部落 (Chongbuluo)
- 联合早报 (Lianhe Zaobao)
- 酷安 (Coolapk)
- 远景论坛 (PCBeta)
- 参考消息 (Cankao Xiaoxi)
- 卫星通讯社 (Sputnik News)
- 百度贴吧 (Baidu Tieba)
- 靠谱新闻 (Kaopu News)
- and more...

## Default Configuration

If no news sources are configured, the plugin uses the following default configuration:

```
澎湃新闻;百度热搜;财联社
```

## Usage

1. **Configure news sources**: Set the Chinese names of the news sources in the web interface or the config file, separated by semicolons
2. **Call the plugin**: Users can say "broadcast the news" or "get the news"
3. **Specify a news source**: Users can say "broadcast The Paper news" or "get Baidu Hot Search"
4. **Get details**: Users can say "give me more details on this news item"

## How It Works

1. The plugin accepts a Chinese name as a parameter (such as "澎湃新闻")
2. Based on the configured news source list, the Chinese name is converted to the corresponding English ID (such as "thepaper")
3. The English ID is used to call the API and fetch the news data
4. The news content is returned to the user

## Notes

1. The configured Chinese names must exactly match the names defined in CHANNEL_MAP
2. After changing the configuration, restart the service or reload the configuration
3. If a configured news source is invalid, the plugin automatically falls back to the default news sources
4. Separate multiple news sources with the ASCII semicolon (;), not the Chinese semicolon (；)