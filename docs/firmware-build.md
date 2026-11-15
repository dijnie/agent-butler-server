# ESP32 Firmware Build

## Step 1: Prepare your OTA address

If you use version 0.3.12 of this project, there is an OTA address whether you use the simple Server deployment or the full-module deployment.

The OTA address is set differently in the simple Server deployment and the full-module deployment, so choose the specific method below:

### If you use the simple Server deployment
Now open your OTA address in a browser, for example my OTA address is
```
http://192.168.1.25:8003/xiaozhi/ota/
```
If it shows "OTA endpoint is running normally. The websocket address sent to devices is: ws://xxx:8000/xiaozhi/v1/

You can start the `digital-human` module and open `index.html` to test whether it can connect to the websocket address shown on the OTA page.

If it cannot be reached, change the `server.websocket` address in the config file `.config.yaml`, restart, and test again until `index.html` works.

Once it succeeds, go on to Step 2

### If you use the full-module deployment
Now open your OTA address in a browser, for example my OTA address is
```
http://192.168.1.25:8002/xiaozhi/ota/
```

If it shows "OTA interface is running normally, number of websocket cluster nodes: X", go on to Step 2.

If it shows "OTA interface is not working properly", you probably have not configured the `Websocket` address in the `control console`. In that case:

- 1. Log in to the control console as a super administrator

- 2. Click `Params Management` in the top menu

- 3. Find the `server.websocket` item in the list and enter your `Websocket` address. For example mine is

```
ws://192.168.1.25:8000/xiaozhi/v1/
```

After configuring, refresh your OTA interface address in the browser and check whether it is normal now. If it is still not normal, confirm again that the Websocket has started normally and that the Websocket address is configured.

## Step 2: Set up the environment
First set up the project environment by following this tutorial: ["Setting up the ESP IDF 5.3.2 development environment on Windows and building Xiaozhi"](https://icnynnzcwou8.feishu.cn/wiki/JEYDwTTALi5s2zkGlFGcDiRknXf) (in Chinese)

## Step 3: Open the config file
After setting up the build environment, download the source code of Xia Ge's xiaozhi-esp32 project,

Download Xia Ge's [xiaozhi-esp32 source code](https://github.com/78/xiaozhi-esp32) from here.

After downloading, open the `xiaozhi-esp32/main/Kconfig.projbuild` file.

## Step 4: Change the OTA address

Find the content of `default` for `OTA_URL`, and change `https://api.tenclass.net/xiaozhi/ota/`
   to your own address. For example, my interface address is `http://192.168.1.25:8002/xiaozhi/ota/`, so change the content to that.

Before the change:
```
config OTA_URL
    string "Default OTA URL"
    default "https://api.tenclass.net/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```
After the change:
```
config OTA_URL
    string "Default OTA URL"
    default "http://192.168.1.25:8002/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```

## Step 4: Set the build parameters

Set the build parameters

```
# In a terminal, go to the root directory of xiaozhi-esp32
cd xiaozhi-esp32
# For example, the board I use is esp32s3, so I set the build target to esp32s3. If your board is another model, replace it with the matching one
idf.py set-target esp32s3
# Enter the menu configuration
idf.py menuconfig
```

After entering the menu configuration, go into `Xiaozhi Assistant` and set `BOARD_TYPE` to the exact model of your board.
Save and exit, and return to the terminal command line.

## Step 5: Build the firmware

```
idf.py build
```

## Step 6: Package the bin firmware

```
cd scripts
python release.py
```

After the packaging commands above finish, the firmware file `merged-binary.bin` is generated in the `build` directory under the project root.
This `merged-binary.bin` is the firmware file to flash to the hardware.

Note: if the second command reports a "zip"-related error, ignore it. As long as the firmware file `merged-binary.bin` is generated in the `build` directory,
it does not matter much, so please continue.

## Step 7: Flash the firmware
   Connect the esp32 device to the computer, use the Chrome browser, and open the following URL

```
https://espressif.github.io/esp-launchpad/
```

Open this tutorial, [Flash tool / Web-based firmware flashing (no IDF development environment)](https://ccnphfhqs21z.feishu.cn/wiki/Zpz4wXBtdimBrLk25WdcXzxcnNS) (in Chinese).
Scroll to `Method 2: ESP-Launchpad browser-based flashing`, and follow the tutorial starting from `3. Flash the firmware / download to the board`.

After flashing succeeds and the device is online, wake Xiaozhi with the wake word and watch the console output on the server side.

## FAQ
Here are some common questions for reference:

[1. Why does Xiaozhi recognize a lot of Korean, Japanese, and English from what I say?](./FAQ.md)

[2. Why does the error "TTS task error: file does not exist" appear?](./FAQ.md)

[3. TTS often fails or times out](./FAQ.md)

[4. The device can connect to a self-hosted server over Wi-Fi, but not in 4G mode](./FAQ.md)

[5. How can I improve Xiaozhi's conversation response speed?](./FAQ.md)

[6. I speak slowly and Xiaozhi keeps cutting in when I pause](./FAQ.md)

[7. I want to use Xiaozhi to control lights, air conditioners, remote power on/off, and so on](./FAQ.md)
