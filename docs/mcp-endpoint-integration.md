# MCP Endpoint Usage Guide

This tutorial uses Xia Ge's open-source MCP calculator as an example to show how to connect your own custom MCP service to your own endpoint.

This tutorial assumes that your `xiaozhi-server` has the MCP endpoint feature enabled. If you have not enabled it yet, first follow [this tutorial](./mcp-endpoint-enable.md).

# How to connect a simple MCP feature, such as a calculator, to an agent

### If you use the full-module deployment
If you use the full-module deployment, go to the control console, Agents, and click `Config Role`. To the right of `Intent Recognition` there is an `Edit Functions` button.

Click this button. In the pop-up page, at the bottom, there is `MCP Access Point`, which normally shows this agent's `MCP endpoint address`. Next we will extend this agent with a calculator feature based on MCP.

This `MCP endpoint address` is important; you will use it in a moment.

### If you use the single-module deployment
If you use the single-module deployment and have already configured the MCP endpoint address in the config file, the single module normally prints the following log when it starts.
```
250705[__main__]-INFO-Initializing component: vad succeeded SileroVAD
250705[__main__]-INFO-Initializing component: asr succeeded FunASRServer
250705[__main__]-INFO-OTA interface is          http://192.168.1.25:8002/xiaozhi/ota/
250705[__main__]-INFO-Vision analysis interface is     http://192.168.1.25:8002/mcp/vision/explain
250705[__main__]-INFO-MCP endpoint is        ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
250705[__main__]-INFO-Websocket address is    ws://192.168.1.25:8000/xiaozhi/v1/
250705[__main__]-INFO-=======The addresses above are websocket protocol addresses, do not open them in a browser=======
250705[__main__]-INFO-To test websocket, start the digital-human module and test interactively in a browser
250705[__main__]-INFO-=============================================================
```

As above, `ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc` in the `MCP endpoint is` output is your `MCP endpoint address`.

This `MCP endpoint address` is important; you will use it in a moment.

## Step 1: Download Xia Ge's MCP calculator project code

Open Xia Ge's [calculator project](https://github.com/78/mcp-calculator) in a browser,

On the page, find the green button labeled `Code`, click it, and you will see the `Download ZIP` button.

Click it to download the project source archive. After it downloads to your computer, extract it. Its name may be `mcp-calculator-main`
You need to rename it to `mcp-calculator`. Next, we use the command line to enter the project directory and install the dependencies


```bash
# Go to the project directory
cd mcp-calculator

conda remove -n mcp-calculator --all -y
conda create -n mcp-calculator python=3.10 -y
conda activate mcp-calculator

pip install -r requirements.txt
```

## Step 2: Start

Before starting, copy the MCP endpoint address from the agent in your control console.

For example, my agent's MCP address is
```
ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
```

Start entering the commands

```bash
export MCP_ENDPOINT=ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc
```

After entering them, start the program

```bash
python mcp_pipe.py calculator.py
```

### If you use the control console deployment
If you use the control console deployment, after it starts, go back to the control console and click refresh MCP connection status, and you will see the list of features you added.

### If you use the single-module deployment
If you use the single-module deployment, after the device connects, it prints a log like the following, which means it succeeded

```
250705 -INFO-Initializing MCP endpoint: wss://2662r3426b.vicp.fun/mcp_e  
250705 -INFO-Sending MCP endpoint initialization message
250705 -INFO-MCP endpoint connected successfully
250705 -INFO-MCP endpoint initialized successfully
250705 -INFO-Unified tool handler initialization complete
250705 -INFO-MCP endpoint server info: name=Calculator, version=1.9.4
250705 -INFO-Number of tools supported by the MCP endpoint: 1
250705 -INFO-All MCP endpoint tools retrieved, client ready
250705 -INFO-Tool cache refreshed
250705 -INFO-Currently supported function list: [ 'get_time', 'get_lunar', 'play_music', 'get_weather', 'handle_exit_intent', 'calculator']
```
If it includes `'calculator'`, the device can call the calculator tool based on intent recognition.