# Configure a Custom Server Using Firmware Pre-Built by Xia Ge

## Step 1: Confirm the version
Flash the firmware already built by Xia Ge, [version 1.6.1 or later](https://github.com/78/xiaozhi-esp32/releases)

## Step 2: Prepare your OTA address
If you followed the tutorial and used the full-module deployment, you should have an OTA address.

Now open your OTA address in a browser, for example my OTA address is
```
https://2662r3426b.vicp.fun/xiaozhi/ota/
```

If it shows "OTA interface is running normally, number of websocket cluster nodes: X", continue.

If it shows "OTA interface is not working properly", you probably have not configured the `Websocket` address in the `control console`. In that case:

- 1. Log in to the control console as a super administrator

- 2. Click `Params Management` in the top menu

- 3. Find the `server.websocket` item in the list and enter your `Websocket` address. For example mine is

```
wss://2662r3426b.vicp.fun/xiaozhi/v1/
```

After configuring, refresh your OTA interface address in the browser and check whether it is normal now. If it is still not normal, confirm again that the Websocket has started normally and that the Websocket address is configured.

## Step 3: Enter network configuration mode
Put the device into network configuration mode, click "Advanced Options" at the top of the page, enter your server's `ota` address in it, and click Save. Restart the device
![See: OTA address setting](../docs/images/firmware-setting-ota.png)

## Step 4: Wake Xiaozhi and check the log output

Wake Xiaozhi and see whether the log output is normal.


## FAQ
Here are some common questions for reference:

[1. Why does Xiaozhi recognize a lot of Korean, Japanese, and English from what I say?](./FAQ.md)

[2. Why does the error "TTS task error: file does not exist" appear?](./FAQ.md)

[3. TTS often fails or times out](./FAQ.md)

[4. The device can connect to a self-hosted server over Wi-Fi, but not in 4G mode](./FAQ.md)

[5. How can I improve Xiaozhi's conversation response speed?](./FAQ.md)

[6. I speak slowly and Xiaozhi keeps cutting in when I pause](./FAQ.md)

[7. I want to use Xiaozhi to control lights, air conditioners, remote power on/off, and so on](./FAQ.md)
