# Weather Plugin Guide

## Overview

The weather plugin `get_weather` is one of the core features of the Xiaozhi ESP32 voice assistant. It supports querying weather information for places across China by voice. The plugin is based on the QWeather (和风天气) API and provides real-time weather and a 7-day forecast.

## API Key Application Guide

### 1. Register a QWeather account

1. Visit the [QWeather console](https://console.qweather.com/)
2. Register an account and complete email verification
3. Log in to the console

### 2. Create an application to get an API Key

1. After entering the console, click ["Project Management"](https://console.qweather.com/project?lang=zh) on the right → "Create Project"
2. Fill in the project information:
   - **Project name**: for example "Xiaozhi voice assistant"
3. Click Save
4. After the project is created, click "Create Credential" in that project
5. Fill in the credential information:
    - **Credential name**: for example "Xiaozhi voice assistant"
    - **Authentication method**: choose "API Key"
6. Click Save
7. Copy the `API Key` from the credential. This is the first key piece of configuration information

### 3. Get the API Host

1. In the console, click ["Settings"](https://console.qweather.com/setting?lang=zh) → "API Host"
2. View the dedicated `API Host` address assigned to you. This is the second key piece of configuration information

The steps above give you two important pieces of configuration information: the `API Key` and the `API Host`

## Configuration (choose either one)

### Option 1. If you deploy with the control console (recommended)

1. Log in to the control console
2. Go to the "Role Configuration" page
3. Select the agent you want to configure
4. Click the "Edit Functions" button
5. In the parameter configuration area on the right, find the "Weather" plugin
6. Check "Weather"
7. Enter the first key piece of configuration, the `API Key` you copied, into the field `天气插件 API 密钥` (weather plugin API key)
8. Enter the second key piece of configuration, the `API Host` you copied, into the field `开发者 API Host` (developer API Host)
9. Save the configuration, then save the agent configuration

### Option 2. If you only deploy the single-module xiaozhi-server

Configure in `data/.config.yaml`:

1. Enter the first key piece of configuration, the `API Key` you copied, into `api_key`
2. Enter the second key piece of configuration, the `API Host` you copied, into `api_host`
3. Enter your city in `default_location`, for example `广州` (Guangzhou)

```yaml
plugins:
  get_weather:
    api_key: "your QWeather API key"
    api_host: "your QWeather API host address"
    default_location: "your default city to query"
```

