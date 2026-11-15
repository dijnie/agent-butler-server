# Xiaozhi ESP32 Open-Source Server and HomeAssistant Integration Guide

[TOC]

-----

## Introduction

This document guides you through integrating an ESP32 device with HomeAssistant.

## Prerequisites

- `HomeAssistant` is installed and configured
- The model I chose this time is the free ChatGLM, which supports function calling

## Preparation (required)

### 1. Get the network address of HA

Visit the network address of your Home Assistant. For example, my HA address is 192.168.4.7 and the port is the default 8123, so I open this in a browser

```
http://192.168.4.7:8123
```

> How to look up the HA IP address manually **(only when the Xiaozhi esp32-server and HA are deployed on the same network [for example, the same wifi])**:
>
> 1. Open Home Assistant (the web front end).
>
> 2. Click **Settings** at the bottom left -> **System** -> **Network**.
>
> 3. Scroll to the bottom to the `Home Assistant website` area. Under `local network`, click the `eye` button to see the IP address in use (such as `192.168.1.10`) and the network interface. Click `copy link` to copy it directly.
>
>    ![image-20250504051716417](images/image-ha-integration-01.png)

Or, if you have set up a directly accessible OAuth address for Home Assistant, you can also open it directly in a browser

```
http://homeassistant.local:8123
```

### 2. Log in to `Home Assistant` and get the API key

Log in to `HomeAssistant`, click `avatar at the bottom left -> Profile`, switch to the `Security` tab, and scroll to the bottom to generate an api_key under `Long-lived access tokens`. Copy and save it. All the methods below need this api key, and it is shown only once (tip: you can save the generated QR code image and scan it later to extract the api key again).

## Method 1: HA Calling Function Built by the Xiaozhi Community

### Description

- If you add new devices later, this method requires manually restarting the `xiaozhi-esp32-server` server to update the device information **(important)**.

- Make sure `Xiaomi Home` is integrated in HomeAssistant and your Mijia devices are imported into `HomeAssistant`.

- Make sure the `xiaozhi-esp32-server control console` works normally.

- My `xiaozhi-esp32-server control console` and `HomeAssistant` are deployed on the same machine on a different port, and the version is `0.3.10`

  ```
  http://192.168.4.7:8002
  ```


### Configuration Steps

#### 1. Log in to `HomeAssistant` and compile the list of devices to control

Log in to `HomeAssistant`, click `Settings at the bottom left`, go to `Devices & services`, then click `Entities` at the top.

Then search the entities for the switch you want to control. When the results appear, click one of them in the list and a switch panel appears.

On the switch panel, try clicking the switch to see whether it turns on and off as you click. If it works, the device is online normally.

Then find the settings button on the switch panel and click it to see the `entity ID` of this switch.

Open a notepad and compile an entry in this format:

location + English comma + device name + English comma + `entity ID` + English semicolon

For example, I am at the office and have a toy light whose identifier is switch.cuco_cn_460494544_cp1_on_p_2_1, so I write this entry

```
Office,Toy light,switch.cuco_cn_460494544_cp1_on_p_2_1;
```

In the end I may want to control two lights, so my final result is:

```
Office,Toy light,switch.cuco_cn_460494544_cp1_on_p_2_1;
Office,Desk lamp,switch.iot_cn_831898993_socn1_on_p_2_1;
```

We call this string the "device list string". Save it; you will need it shortly.

#### 2. Log in to the `control console`

![image-20250504051716417](images/image-ha-integration-06.png)

Log in to the `control console` with an administrator account. In `Agents`, find your agent and click `Config Role`.

Set Intent Recognition to `External LLM intent recognition` or `LLM function calling`. You will then see `Edit Functions` on the right. Click the `Edit Functions` button and the `Function Management` dialog pops up.

In the `Function Management` dialog, check `HomeAssistant device status query` and `HomeAssistant device status modification`.

After checking them, click `HomeAssistant device status query` under `Selected Functions`, then configure your `HomeAssistant` address, key, and device list string under `Parameter Configuration`.

After editing, click `Save Configuration`. The `Function Management` dialog closes, and you then click save for the agent configuration.

After saving successfully, you can wake the device and operate it.

#### 3. Wake the device to control it

Try saying to the esp32, "Turn on the XXX light"

## Method 2: Xiaozhi Uses the Home Assistant Voice Assistant as an LLM Tool

### Description

- This method has a serious drawback: **it cannot use the function_call plugin capabilities of the Xiaozhi open-source ecosystem**, because using Home Assistant as Xiaozhi's LLM tool hands intent recognition over to Home Assistant. However, **this method gives you the native Home Assistant control experience, and Xiaozhi's chat ability stays the same**. If you really mind, you can use [Method 3](#method-3-use-the-home-assistant-mcp-service-recommended), which is also supported by Home Assistant and gives the fullest Home Assistant experience.

### Configuration Steps:

#### 1. Configure the large model voice assistant of Home Assistant.

**You need to configure the Home Assistant voice assistant or large model tool in advance.**

#### 2. Get the Agent ID of the Home Assistant voice assistant.

1. Open the Home Assistant page and click `Developer tools` on the left.
2. In `Developer tools`, click the `Actions` tab (operation 1 in the figure). In the `Action` drop-down on the page, find or type `conversation.process (Conversation: Process)` and select `Conversation: Process` (operation 2 in the figure).

![image-20250504043539343](images/image-ha-integration-02.png)

3. On the page, check the `agent` option, then in the `conversation agent` field that becomes active, select the name of the voice assistant you configured in step 1. In the figure, mine is `ZhipuAi`.

![image-20250504043854760](images/image-ha-integration-03.png)

4. After selecting it, click `Go to YAML mode` at the bottom left of the form.

![image-20250504043951126](images/image-ha-integration-04.png)

5. Copy the value of agent-id. For example, mine in the figure is `01JP2DYMBDF7F4ZA2DMCF2AGX2` (for reference only).

![image-20250504044046466](images/image-ha-integration-05.png)

6. Switch to the `config.yaml` file of the Xiaozhi open-source server `xiaozhi-esp32-server`. In the LLM configuration, find Home Assistant and set your Home Assistant network address, Api key, and the agent_id you just looked up.
7. In `config.yaml`, set `LLM` under `selected_module` to `HomeAssistant` and `Intent` to `nointent`.
8. Restart the Xiaozhi open-source server `xiaozhi-esp32-server` and it works normally.

## Method 3: Use the Home Assistant MCP Service (Recommended)

### Description

- Integrate and install the HA integration [Model Context Protocol Server](https://www.home-assistant.io/integrations/mcp_server/) in Home Assistant in advance.

- Like Method 2, this method is an official HA solution. Unlike Method 2, you can use the community-built plugins of the Xiaozhi open-source server `xiaozhi-esp32-server` normally, and you may use any LLM that supports function_call.

### Configuration Steps

#### 1. Install the Home Assistant MCP server integration.

Official integration page: [Model Context Protocol Server](https://www.home-assistant.io/integrations/mcp_server/).

Or follow the manual steps below.

> - Go to **[Settings > Devices & Services](https://my.home-assistant.io/redirect/integrations)**.
>
> - At the bottom right, select the **[Add Integration](https://my.home-assistant.io/redirect/config_flow_start?domain=mcp_server)** button.
>
> - Select **Model Context Protocol Server** from the list.
>
> - Follow the on-screen instructions to complete the setup.

#### 2. Configure the MCP settings of the Xiaozhi open-source server


Go to the `data` directory and find the `.mcp_server_settings.json` file.

If there is no `.mcp_server_settings.json` file in your `data` directory,
- copy the `mcp_server_settings.json` file from the root of the `xiaozhi-server` folder into the `data` directory and rename it to `.mcp_server_settings.json`
- or [download this file](https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/main/xiaozhi-server/mcp_server_settings.json); download it into the `data` directory and rename it to `.mcp_server_settings.json`


Modify this part inside `"mcpServers"`:

```json
"Home Assistant": {
      "command": "mcp-proxy",
      "args": [
        "http://YOUR_HA_HOST/mcp_server/sse"
      ],
      "env": {
        "API_ACCESS_TOKEN": "YOUR_API_ACCESS_TOKEN"
      }
},
```

Notes:

1. **Replace the settings:**
   - Replace `YOUR_HA_HOST` in `args` with your HA service address. If your service address already includes https/http (for example `http://192.168.1.101:8123`), enter only `192.168.1.101:8123`.
   - Replace `YOUR_API_ACCESS_TOKEN` of `API_ACCESS_TOKEN` in `env` with the api key you obtained earlier.
2. **If you add the settings inside the `"mcpServers"` braces and no other `mcpServers` entries follow, remove the trailing comma `,`**; otherwise parsing may fail.

**The final result should look like this (for reference):**

```json
 "mcpServers": {
    "Home Assistant": {
      "command": "mcp-proxy",
      "args": [
        "http://192.168.1.101:8123/mcp_server/sse"
      ],
      "env": {
        "API_ACCESS_TOKEN": "abcd.efghi.jkl"
      }
    }
  }
```

#### 3. Configure the system settings of the Xiaozhi open-source server

1. **Choose any LLM that supports function_call as Xiaozhi's LLM chat assistant (but do not choose Home Assistant as the LLM tool)**. The model I chose this time is the free ChatGLM, which supports function calling but is sometimes unstable. If you want stability, set the LLM to DoubaoLLM with the specific model_name: doubao-1-5-pro-32k-250115.

2. Switch to the `config.yaml` file of the Xiaozhi open-source server `xiaozhi-esp32-server`, set your LLM configuration, and change `Intent` in `selected_module` to `function_call`.

3. Restart the Xiaozhi open-source server `xiaozhi-esp32-server` and it works normally.