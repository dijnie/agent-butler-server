# Single-Module Deployment: Firmware OTA Auto-Upgrade Configuration Guide

This tutorial shows you how to configure automatic firmware OTA upgrades in a **single-module deployment**, so device firmware updates automatically.

If you use the **full-module deployment**, ignore this tutorial.

## Overview

In a single-module deployment, xiaozhi-server has a built-in OTA firmware management feature that detects the device version and pushes upgrade firmware automatically. Based on the device model and current version, the system matches and pushes the latest firmware version.

## Prerequisites

- You have successfully completed a **single-module deployment** and xiaozhi-server is running
- Devices can connect to the server normally

## Step 1: Prepare the firmware file

### 1. Create the firmware directory

Firmware files must be placed in the `data/bin/` directory. If it does not exist, create it manually:

```bash
mkdir -p data/bin
```

### 2. Firmware file naming rules

Firmware files must follow this naming format:

```
{device_model}_{version}.bin
```

**Naming rules:**
- `device_model`: the model name of the device, for example `lichuang-dev` or `bread-compact-wifi`
- `version`: the firmware version, which must start with a digit and may contain digits, letters, dots, underscores, and hyphens, for example `1.6.6` or `2.0.0`
- The file extension must be `.bin`

**Naming examples:**
```
bread-compact-wifi_1.6.6.bin
lichuang-dev_2.0.0.bin
```

### 3. Place the firmware file

Copy the prepared firmware file (.bin file) into the `data/bin/` directory:

Important, said three times: the upgrade bin file is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

Important, said three times: the upgrade bin file is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

Important, said three times: the upgrade bin file is `xiaozhi.bin`, not the full firmware file `merged-binary.bin`!

```bash
cp xiaozhi.bin data/bin/device_model_version.bin
```

For example:
```bash
cp xiaozhi.bin data/bin/bread-compact-wifi_1.6.6.bin
```

## Step 2: Configure the public access address (public deployment only)

**Note: this step only applies to single-module public deployments.**

If your xiaozhi-server is deployed on the public internet (using a public IP or domain name), you **must** configure the `server.vision_explain` parameter, because the OTA firmware download address uses the domain name and port configured there.

If you deploy on a LAN, you can skip this step.

### Why configure this parameter?

In a single-module deployment, the system uses the domain name and port configured in `vision_explain` as the base address when generating the firmware download address. If it is missing or wrong, devices cannot reach the firmware download address.

### How to configure

Open the `data/.config.yaml` file, find the `server` section, and set the `vision_explain` parameter:

```yaml
server:
  vision_explain: http://your-domain-or-IP:port/mcp/vision/explain
```

**Configuration examples:**

LAN deployment (default):
```yaml
server:
  vision_explain: http://192.168.1.100:8003/mcp/vision/explain
```

Public domain deployment:
```yaml
server:
  vision_explain: http://yourdomain.com:8003/mcp/vision/explain
```

### Notes

- The domain name or IP must be an address that devices can reach
- If you deploy with Docker, do not use a Docker-internal address (such as 127.0.0.1 or localhost)
- If you use an nginx reverse proxy, enter the external address and port, not the port this project runs on


## FAQ

### 1. The device does not receive the firmware update

**Possible causes and solutions:**

- Check that the firmware file name follows the rule: `{model}_{version}.bin`
- Check that the firmware file is placed in the `data/bin/` directory
- Check that the device model matches the model in the firmware file name
- Check that the firmware version is higher than the device's current version
- Check the server logs to confirm the OTA request is handled normally

### 2. The device reports that the download address is unreachable

**Possible causes and solutions:**

- Check that the domain name or IP configured in `server.vision_explain` is correct
- Confirm the port is configured correctly (default 8003)
- For a public deployment, make sure the device can reach that public address
- For a Docker deployment, make sure you did not use an internal address (127.0.0.1)
- Check that the firewall allows the corresponding port
- If you use an nginx reverse proxy, enter the external address and port, not the port this project runs on

### 3. How to confirm the device's current version

Check the OTA request log, which shows the version reported by the device:

```
[ota_handler] - Device AA:BB:CC:DD:EE:FF firmware is already up to date: 1.6.6
```

### 4. The firmware file does not take effect after being placed

The system has a cache time of 30 seconds (default). You can:
- Wait 30 seconds before letting the device send an OTA request
- Restart the xiaozhi-server service
- Set `firmware_cache_ttl` to a shorter time
