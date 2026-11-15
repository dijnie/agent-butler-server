# Web Search Plugin Guide

## Overview

The web search plugin `web_search` can search the web in real time during a conversation and return the results. The plugin supports four search providers: Metaso (秘塔), Tavily, Serply, and Outcrawl. You can choose one of them as needed.

## API Key Application Guide

We currently support `Metaso search`, `Tavily search`, `Serply search`, and `Outcrawl search`.
- Tavily search: 1000 free calls per month.
- Metaso search: has fairly high-quality domestic (China) data sources.
- Serply search: returns Google search results, with 2500 free calls on registration; after the quota is used up you must pay.
- Outcrawl search: a web search API for AI agents, with a free quota of 1000 credits per month.

## API Key Application Guide

### Option 1: Use Metaso search

- Visit the [Metaso search API](https://metaso.cn/search-api/api-keys), register and log in
- On the API key management page, click "Create new key"
- Copy the generated API Key (prefixed with `mk-`), which is key information needed for the configuration

### Option 2: Use Tavily search

- Visit the [Tavily console](https://app.tavily.com/home), register and log in
- Create an API Key in the console
- Copy the generated API Key (prefixed with `tvly-`), which is key information needed for the configuration

### Option 3: Use Serply search

- Visit [Serply](https://serply.io), register and log in
- Create an API Key in the console
- Copy the generated API Key, which is key information needed for the configuration
- For the API reference, see the [Serply docs](https://serply.io/docs)

### Option 4: Use Outcrawl search

- Visit [Outcrawl](https://outcrawl.ai), register and log in
- Create an API Key in the console
- Copy the generated API Key, which is key information needed for the configuration
- For the API reference, see the [Outcrawl docs](https://outcrawl.ai/docs/search/overview)

## Configuration

### Option 1. Deploy with the control console (recommended)

- Log in to the control console
- Go to the "Role Configuration" page and select the agent you want to configure
- Click the "Edit Functions" button and find the "Web search" plugin in the parameter configuration area on the right
- Check "Web search"
- Enter the search provider (`metaso`, `tavily`, `serply`, or `outcrawl`) and enter the corresponding `API Key` in the configuration item
- Save the configuration, then save the agent configuration

### Option 2. Single-module xiaozhi-server deployment

Configure in `data/.config.yaml`:

- Enter the search provider in `provider`; the allowed values are `metaso`, `tavily`, `serply`, or `outcrawl`
- Enter the API Key you obtained in `api_key`

```yaml
plugins:
  web_search:
    provider: "metaso"
    api_key: "your API Key"
```

To customize the number of returned results and the tool description, you can additionally configure `max_results` and `description`:

```yaml
plugins:
  web_search:
    provider: "metaso"
    description: "Web search tool. Use this tool when the user explicitly needs to search the web for a question."
    max_results: 5
    api_key: "your API Key"
```

Also make sure `web_search` is enabled in the `functions` list:

```yaml
plugins:
  functions:
    - web_search
```

After configuring, restart the service for it to take effect.
