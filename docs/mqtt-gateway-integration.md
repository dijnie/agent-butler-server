# MQTT Gateway Deployment Guide

The `xiaozhi-esp32-server` project can be combined with Xia Ge's open-source [xiaozhi-mqtt-gateway](https://github.com/78/xiaozhi-mqtt-gateway) project, with a few simple changes, to give Xiaozhi hardware an MQTT+UDP connection.
This tutorial has three parts. Depending on whether you use the full-module or the single-module deployment, choose the matching part to connect the MQTT gateway:
- Part 1: Deploy the MQTT gateway
- Part 2: Full-module deployment: MQTT+UDP connection for Xiaozhi hardware
- Part 3: Single-module xiaozhi-server: MQTT+UDP connection for Xiaozhi hardware

## Preparation
Prepare the `mqtt-websocket` connection address of your `xiaozhi-server`. Add the string `?from=mqtt_gateway` to your original `websocket address` to get the `mqtt-websocket` connection address

1. If you deploy from source, your `mqtt-websocket` address is:
```
ws://127.0.0.1:8000/xiaozhi/v1/?from=mqtt_gateway
```

2. If you deploy with docker, your `mqtt-websocket` address is
```
ws://your-host-LAN-IP:8000/xiaozhi/v1/?from=mqtt_gateway
```

## Important

If you deploy on a server, make sure ports `1883`, `8884`, and `8007` are open to the outside. Choose the protocol `UDP` for `8884`; the others are `TCP`.

If you deploy on a server, make sure ports `1883`, `8884`, and `8007` are open to the outside. Choose the protocol `UDP` for `8884`; the others are `TCP`.

If you deploy on a server, make sure ports `1883`, `8884`, and `8007` are open to the outside. Choose the protocol `UDP` for `8884`; the others are `TCP`.


## Part 1: Deploy the MQTT gateway

1. Clone the [modified xiaozhi-mqtt-gateway project](https://github.com/xinnan-tech/xiaozhi-mqtt-gateway.git):
```bash
git clone https://ghfast.top/https://github.com/xinnan-tech/xiaozhi-mqtt-gateway.git
cd xiaozhi-mqtt-gateway
```

2. Install dependencies:
```bash
npm install
npm install -g pm2
```

3. Configure `config.json`:
```bash
cp config/mqtt.json.example config/mqtt.json
```

4. Edit the config file config/mqtt.json and replace the `mqtt-websocket` address from the `Preparation` section of this document into `chat_servers`. For example, for a source-deployed `xiaozhi-server` the configuration is as follows:

``` 
{
    "production": {
        "chat_servers": [
            "ws://127.0.0.1:8000/xiaozhi/v1/?from=mqtt_gateway"
        ]
    },
    "debug": false,
    "max_mqtt_payload_size": 8192,
    "mcp_client": {
        "capabilities": {
        },
        "client_info": {
            "name": "xiaozhi-mqtt-client",
            "version": "1.0.0"
        },
        "max_tools_count": 128
    }
}
```
5. Create a `.env` file in the project root and set the following environment variables:
```
PUBLIC_IP=your-ip         # Server public IP
MQTT_PORT=1883            # MQTT server port
UDP_PORT=8884             # UDP server port
API_PORT=8007             # Management API port
MQTT_SIGNATURE_KEY=test   # MQTT signature key
SERVER_SECRET=Te1st12134  # Server secret. Keep it the same as the control console (server.secret) or the one in xiaozhi-server (server.auth_key)
```
Note the `PUBLIC_IP` setting: make sure it matches the actual public IP, or enter the domain name if you have one.

`MQTT_SIGNATURE_KEY` is the key used to authenticate MQTT connections. It is best to make it complex, ideally at least 8 characters containing both upper and lower case letters. You will use this key again later.

- Do not use simple passwords such as `123456` or `test`.
- Do not use simple passwords such as `123456` or `test`.
- Do not use simple passwords such as `123456` or `test`.

`SERVER_SECRET` is used to generate the authentication information for websocket connections.

1. If you use the full-module deployment and `server.auth.enabled` is set to `true` in the Params Management page of the control console, `SERVER_SECRET` must match the control console value (`server.secret`).

2. If you use the single-module deployment and you set `server.auth.enabled` to `true` in the config file, `SERVER_SECRET` must match the value in the config file (`server.auth_key`).


6. Start the MQTT gateway
```
# Start the service
pm2 start ecosystem.config.js

# View the log
pm2 logs xz-mqtt
```

When you see the following log, the MQTT gateway started successfully:
```
0|xz-mqtt  | 2025-09-11T12:14:48: MQTT server is listening on port 1883
0|xz-mqtt  | 2025-09-11T12:14:48: UDP server is listening on x.x.x.x:8884
```

To restart the MQTT gateway, run the following command:
```
pm2 restart xz-mqtt
```

## Part 2: Full-module deployment: MQTT+UDP connection for Xiaozhi hardware

Check the version number at the bottom of the control console home page and confirm it is `0.7.7` or later. If not, upgrade the control console.

1. At the top of the control console, click `Params Management`, search for `server.mqtt_gateway`, click edit, and enter the `PUBLIC_IP` + `:` + `MQTT_PORT` you set in the `.env` file. Like this
```
192.168.0.7:1883
```
2. At the top of the control console, click `Params Management`, search for `server.mqtt_signature_key`, click edit, and enter the `MQTT_SIGNATURE_KEY` you set in the `.env` file.

3. At the top of the control console, click `Params Management`, search for `server.udp_gateway`, click edit, and enter the `PUBLIC_IP` + `:` + `UDP_PORT` you set in the `.env` file. Like this
```
192.168.0.7:8884
```
4. At the top of the control console, click `Params Management`, search for `server.mqtt_manager_api`, click edit, and enter the `PUBLIC_IP` + `:` + `API_PORT` you set in the `.env` file. Like this
```
192.168.0.7:8007
```

After the configuration above, you can use a curl command to verify whether your OTA address issues the MQTT configuration. Change `http://localhost:8002/xiaozhi/ota/` below to your OTA address
```
curl 'http://localhost:8002/xiaozhi/ota/' \
  -H 'Content-Type: application/json' \
  -H 'Client-Id: 7b94d69a-9808-4c59-9c9b-704333b38aff' \
  -H 'Device-Id: 11:22:33:44:55:66' \
  --data-raw $'{\n  "application": {\n    "version": "1.0.1",\n    "elf_sha256": "1"\n  },\n  "board": {\n    "mac": "11:22:33:44:55:66"\n  }\n}'
```

If the returned content contains `mqtt`-related configuration, it succeeded. Like this

```
{"server_time":{"timestamp":1757567894012,"timeZone":"Asia/Shanghai","timezone_offset":480},"activation":{"code":"460609","message":"http://xiaozhi.server.com\n460609","challenge":"11:22:33:44:55:66"},"firmware":{"version":"1.0.1","url":"http://xiaozhi.server.com:8002/xiaozhi/otaMag/download/NOT_ACTIVATED_FIRMWARE_THIS_IS_A_INVALID_URL"},"websocket":{"url":"ws://192.168.4.23:8000/xiaozhi/v1/"},"mqtt":{"endpoint":"192.168.0.7:1883","client_id":"GID_default@@@11_22_33_44_55_66@@@7b94d69a-9808-4c59-9c9b-704333b38aff","username":"eyJpcCI6IjA6MDowOjA6MDowOjA6MSJ9","password":"Y8XP9xcUhVIN9OmbCHT9ETBiYNE3l3Z07Wk46wV9PE8=","publish_topic":"device-server","subscribe_topic":"devices/p2p/11_22_33_44_55_66"}}
```

Since the MQTT information is delivered through the OTA address, as long as you make sure the device can connect to the server's OTA address normally, restart the device and wake it up.

After waking it up, watch the mqtt-gateway log and confirm there is a successful connection log.
```
pm2 logs xz-mqtt
```

## Part 3: Single-module xiaozhi-server: MQTT+UDP connection for Xiaozhi hardware

Open your `data/.config.yaml` file, find `mqtt_gateway` under `server`, and enter the `PUBLIC_IP` + `:` + `MQTT_PORT` you set in the `.env` file. Like this
```
192.168.0.7:1883
```
Under `server`, find `mqtt_signature_key` and enter the `MQTT_SIGNATURE_KEY` you set in the `.env` file.

Under `server`, find `udp_gateway` and enter the `PUBLIC_IP` + `:` + `UDP_PORT` you set in the `.env` file. Like this
```
192.168.0.7:8884
```

After the configuration above, you can use a curl command to verify whether your OTA address issues the MQTT configuration. Change `http://localhost:8002/xiaozhi/ota/` below to your OTA address
```
curl 'http://localhost:8002/xiaozhi/ota/' \
  -H 'Device-Id: 11:22:33:44:55:66' \
  --data-raw $'{\n  "application": {\n    "version": "1.0.1",\n    "elf_sha256": "1"\n  },\n  "board": {\n    "mac": "11:22:33:44:55:66"\n  }\n}'
```

If the returned content contains `mqtt`-related configuration, it succeeded. Like this
```
{"server_time":{"timestamp":1758781561083,"timeZone":"GMT+08:00","timezone_offset":480},"activation":{"code":"527111","message":"http://xiaozhi.server.com\n527111","challenge":"11:22:33:44:55:66"},"firmware":{"version":"1.0.1","url":"http://xiaozhi.server.com:8002/xiaozhi/otaMag/download/NOT_ACTIVATED_FIRMWARE_THIS_IS_A_INVALID_URL"},"websocket":{"url":"ws://192.168.1.15:8000/xiaozhi/v1/"},"mqtt":{"endpoint":"192.168.1.15:1883","client_id":"GID_default@@@11_22_33_44_55_66@@@11_22_33_44_55_66","username":"eyJpcCI6IjE5Mi4xNjguMS4xNSJ9","password":"fjAYs49zTJecWqJ3jBt+kqxVn/x7vkXRAc85ak/va7Y=","publish_topic":"device-server","subscribe_topic":"devices/p2p/11_22_33_44_55_66"}}
```

Since the MQTT information is delivered through the OTA address, as long as you make sure the device can connect to the server's OTA address normally, restart the device and wake it up.

After waking it up, watch the mqtt-gateway log and confirm there is a successful connection log.
```
pm2 logs xz-mqtt
```
