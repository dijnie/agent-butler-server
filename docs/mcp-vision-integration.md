# Vision Model Guide
This tutorial has two parts:
- Part 1: Enable the vision model when running xiaozhi-server as a single module
- Part 2: Enable the vision model in a full-module deployment

Before enabling the vision model, you need three things:
- A device with a camera that already has camera calling implemented in Brother Xia's repository, for example the `LCSC Hands-on ESP32-S3 development board`
- Your device firmware upgraded to version 1.6.6 or above
- The basic conversation module already working

## Enable the Vision Model with a Single-Module xiaozhi-server

### Step 1: Confirm the network
The vision model starts port 8003 by default.

If you run with docker, confirm that your `docker-compose.yml` exposes port `8003`. If it does not, update to the latest `docker-compose.yml` file.

If you run from source, confirm that the firewall allows port `8003`.

### Step 2: Choose your vision model
Open your `data/.config.yaml` file and set `selected_module.VLLM` to a vision model. We currently support vision models with an `openai`-type API. `ChatGLMVLLM` is one of the `openai`-compatible models.

```
selected_module:
  VAD: ..
  ASR: ..
  LLM: ..
  VLLM: ChatGLMVLLM
  TTS: ..
  Memory: ..
  Intent: ..
```

Suppose we use `ChatGLMVLLM` as the vision model. We first need to log in to the [Zhipu AI](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) website and apply for a key. If you have already applied for a key, you can reuse it.

Add this configuration to your config file. If it is already there, just set your api_key.

```
VLLM:
  ChatGLMVLLM:
    api_key: your api_key
```

### Step 3: Start the xiaozhi-server service
If you run from source, start it with this command
```
python app.py
```
If you run with docker, restart the container
```
docker restart xiaozhi-esp32-server
```

After startup, logs like the following are printed.

```
2025-06-01 **** - OTA API is           http://192.168.4.7:8003/xiaozhi/ota/
2025-06-01 **** - Vision analysis API is        http://192.168.4.7:8003/mcp/vision/explain
2025-06-01 **** - Websocket address is       ws://192.168.4.7:8000/xiaozhi/v1/
2025-06-01 **** - =======The addresses above are websocket protocol addresses; do not open them in a browser=======
2025-06-01 **** - To test websocket, start the digital-human module and test interactively in a browser
2025-06-01 **** - =============================================================
```

After startup, open the `Vision analysis API` link from the logs in a browser. See what it outputs. If you are on linux without a browser, you can run this command:
```
curl -i your vision analysis API
```

Normally it displays this
```
MCP Vision endpoint is running normally. The vision explain endpoint address is: http://xxxx:8003/mcp/vision/explain
```

Note: if you deploy on a public network or with docker, you must change this setting in your `data/.config.yaml`
```
server:
  vision_explain: http://your-ip-or-domain:port/mcp/vision/explain
```

Why? Because the vision explain API address is sent down to the device. If your address is a LAN address or a docker-internal address, the device cannot reach it.

Suppose your public address is `111.111.111.111`; then `vision_explain` should be configured like this

```
server:
  vision_explain: http://111.111.111.111:8003/mcp/vision/explain
```

If your MCP Vision API runs normally and you can also open the `vision explain API address` sent to the device in a browser, continue to the next step

### Step 4: Wake the device

Say to the device, "Please turn on the camera and tell me what you see"

Watch the xiaozhi-server log output to see whether there are any errors.


## Enable the Vision Model in a Full-Module Deployment

### Step 1: Confirm the network
The vision model starts port 8003 by default.

If you run with docker, confirm that your `docker-compose_all.yml` maps port `8003`. If it does not, update to the latest `docker-compose_all.yml` file.

If you run from source, confirm that the firewall allows port `8003`.

### Step 2: Confirm your config file

Open your `data/.config.yaml` file and check whether its structure is the same as `data/config_from_api.yaml`. If it differs or is missing an item, fill it in.

### Step 3: Configure the vision model key

We first need to log in to the [Zhipu AI](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) website and apply for a key. If you have already applied for a key, you can reuse it.

Log in to the `control console`, click `Models` in the top menu, click `Visual Language Model` in the left sidebar, find `VLLM_ChatGLMVLLM`, and click the edit button. In the dialog, enter your key in `API Key` and click save.

After saving successfully, go to the agent you want to test and click `Config Role`. In the content that opens, check whether `Vision Model` has the vision model you just configured selected. Click save.

### Step 3: Start the xiaozhi-server module
If you run from source, start it with this command
```
python app.py
```
If you run with docker, restart the container
```
docker restart xiaozhi-esp32-server
```

After startup, logs like the following are printed.

```
2025-06-01 **** - Vision analysis API is        http://192.168.4.7:8003/mcp/vision/explain
2025-06-01 **** - Websocket address is       ws://192.168.4.7:8000/xiaozhi/v1/
2025-06-01 **** - =======The addresses above are websocket protocol addresses; do not open them in a browser=======
2025-06-01 **** - To test websocket, start the digital-human module and test interactively in a browser
2025-06-01 **** - =============================================================
```

After startup, open the `Vision analysis API` link from the logs in a browser. See what it outputs. If you are on linux without a browser, you can run this command:
```
curl -i your vision analysis API
```

Normally it displays this
```
MCP Vision endpoint is running normally. The vision explain endpoint address is: http://xxxx:8003/mcp/vision/explain
```

Note: if you deploy on a public network or with docker, you must change this setting in your `data/.config.yaml`
```
server:
  vision_explain: http://your-ip-or-domain:port/mcp/vision/explain
```

Why? Because the vision explain API address is sent down to the device. If your address is a LAN address or a docker-internal address, the device cannot reach it.

Suppose your public address is `111.111.111.111`; then `vision_explain` should be configured like this

```
server:
  vision_explain: http://111.111.111.111:8003/mcp/vision/explain
```

If your MCP Vision API runs normally and you can also open the `vision explain API address` sent to the device in a browser, continue to the next step

### Step 4: Wake the device

Say to the device, "Please turn on the camera and tell me what you see"

Watch the xiaozhi-server log output to see whether there are any errors.
