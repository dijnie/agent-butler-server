# MCP Endpoint Deployment and Usage Guide

This tutorial has 3 parts
- 1. How to deploy the MCP endpoint service
- 2. How to configure the MCP endpoint in a full-module deployment
- 3. How to configure the MCP endpoint in a single-module deployment

# 1. How to deploy the MCP endpoint service

## Step 1: Download the MCP endpoint project source code

Open the [MCP endpoint project page](https://github.com/xinnan-tech/mcp-endpoint-server) in a browser

On the page, find the green button labeled `Code`, click it, and you will see the `Download ZIP` button.

Click it to download the project source archive. After it downloads to your computer, extract it. Its name may be `mcp-endpoint-server-main`
You need to rename it to `mcp-endpoint-server`.

## Step 2: Start the program
This is a very simple project, and we recommend running it with docker. If you do not want to use docker, you can run it from source by following [this page](https://github.com/xinnan-tech/mcp-endpoint-server/blob/main/README_dev.md). The following is the docker method

```
# Go to the project source root
cd mcp-endpoint-server

# Clear the cache
docker compose -f docker-compose.yml down
docker stop mcp-endpoint-server
docker rm mcp-endpoint-server
docker rmi ghcr.nju.edu.cn/xinnan-tech/mcp-endpoint-server:latest

# Start the docker container
docker compose -f docker-compose.yml up -d
# View the log
docker logs -f mcp-endpoint-server
```

The log will then print output similar to the following
```
250705 INFO-=====The addresses below are the control console / single-module MCP endpoint addresses====
250705 INFO-Control console MCP parameter configuration: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
250705 INFO-Single-module deployment MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
250705 INFO-=====Choose according to your deployment, and do not share them with anyone======
```

Copy the two interface addresses:

Because you deploy with docker, never use the addresses above directly!

Because you deploy with docker, never use the addresses above directly!

Because you deploy with docker, never use the addresses above directly!

Copy the addresses into a scratch file. You need to know your computer's LAN IP. For example, if my computer's LAN IP is `192.168.1.25`, then
my original interface addresses
```
Control console MCP parameter configuration: http://172.22.0.2:8004/mcp_endpoint/health?key=abc
Single-module deployment MCP endpoint: ws://172.22.0.2:8004/mcp_endpoint/mcp/?token=def
```
must be changed to
```
Control console MCP parameter configuration: http://192.168.1.25:8004/mcp_endpoint/health?key=abc
Single-module deployment MCP endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After changing them, open the `Control console MCP parameter configuration` address directly in a browser. If the browser shows code like the following, it succeeded.
```
{"result":{"status":"success","connections":{"tool_connections":0,"robot_connections":0,"total_connections":0}},"error":null,"id":null,"jsonrpc":"2.0"}
```

Keep the two `interface addresses` above, because you need them in the next step.

# 2. How to configure the MCP endpoint in a full-module deployment
First, enable the MCP endpoint feature. In the control console, click `More` at the top, and in the drop-down menu click the `System Feature Management` page. On the page check `MCP Access Point` and click `Save Configuration`. On the `Role Configuration` page, click the `Edit Functions` button and you will see the `MCP Access Point` feature.

If you use the full-module deployment, log in to the control console with an administrator account, click `More` at the top, and choose `Params Management`.

Then search for the parameter `server.mcp_endpoint`. Its value should be `null`.
Click the edit button and paste the `Control console MCP parameter configuration` from the previous step into `Parameter Value`. Then save.

If it saves successfully, everything is going well and you can check the result in the agent. If it fails, the control console cannot reach the MCP endpoint, most likely because of a network firewall or an incorrect LAN IP.

# 3. How to configure the MCP endpoint in a single-module deployment

If you use the single-module deployment, find your config file `data/.config.yaml`.
Search the config file for `mcp_endpoint`. If you do not find it, add the `mcp_endpoint` setting. Mine looks like this
```
server:
  websocket: ws://your-IP-or-domain:port/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# There may be more settings here..

mcp_endpoint: your-endpoint-websocket-address
```
Now paste the `Single-module deployment MCP endpoint` obtained in `How to deploy the MCP endpoint service` into `mcp_endpoint`. Like this

```
server:
  websocket: ws://your-IP-or-domain:port/xiaozhi/v1/
  http_port: 8002
log:
  log_level: INFO

# There may be more settings here

mcp_endpoint: ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=def
```

After configuring, starting the single module prints the following log.
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

As above, if the output contains `MCP endpoint is` with `ws://192.168.1.25:8004/mcp_endpoint/mcp/?token=abc`, the configuration succeeded.

