# Deployment Architecture Diagram
![See the minimal architecture diagram](../docs/images/deploy1.png)
# Option 1: Run only the Server with Docker

The docker images released by this project are available for both `amd64` and `arm64` architectures and can be pulled and used directly. To customize the image, follow [this tutorial](docker-build.md) to build it locally.

## 1. Install docker

If docker is not installed on your computer yet, you can install it by following this tutorial: [docker installation](https://www.runoob.com/docker/ubuntu-docker-install.html)

After docker is installed, continue.

### 1.1 Manual deployment

#### 1.1.1 Create the directories

After installing docker, you need to find a directory for this project's configuration files. For example, we can create a folder called `xiaozhi-server`.

After creating the directory, create a `data` folder and a `models` folder under `xiaozhi-server`, and then create a `SenseVoiceSmall` folder under `models`.

The final directory structure is as follows:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.1.2 Download the speech recognition model file

You need to download the speech recognition model file, because this project's default speech recognition uses a local offline solution. You can download it this way:
[Jump to downloading the speech recognition model file](#model-files)

After downloading, return to this tutorial.

#### 1.1.3 Download the configuration files

You need to download two configuration files: `docker-compose.yml` and `config.yaml`. Both files are downloaded from the project repository.

##### 1.1.3.1 Download docker-compose.yml

Open [this link](../main/xiaozhi-server/docker-compose.yml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon and click it to download the `docker-compose.yml` file. Download the file into your
`xiaozhi-server`.

After downloading, return to this tutorial and continue.

##### 1.1.3.2 Create config.yaml

Open [this link](../main/xiaozhi-server/config.yaml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon and click it to download the `config.yaml` file. Download the file into the `data` folder under your
`xiaozhi-server`, then rename the `config.yaml` file to `.config.yaml`.

After downloading the configuration files, let's confirm that the files in `xiaozhi-server` look like this:

```
xiaozhi-server
  ├─ docker-compose.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

If your directory structure matches the one above, continue. If not, look carefully again to see whether you missed a step.

## 2. Configure the project files

Next, the program cannot run yet. You need to configure which models you actually use. You can read this tutorial:
[Jump to configuring the project files](#configure-the-project)

After configuring the project files, return to this tutorial and continue.

## 3. Run the docker commands

Open a command-line tool (`Terminal` or `Command Prompt`), go to your `xiaozhi-server`, and run the following command

```
docker compose up -d
```

After that, run the following command to view the logs.

```
docker logs -f xiaozhi-esp32-server
```

At this point, pay attention to the log output. You can use this tutorial to determine whether it succeeded: [Jump to confirming the running status](#confirm-running-status)

## 4. Upgrade the version

If you want to upgrade the version later, you can do the following

4.1. Back up the `.config.yaml` file in the `data` folder, and later copy the key settings into the new `.config.yaml` file.
Note that you should copy the key secrets one by one and not simply overwrite the file, because the new `.config.yaml` file may contain new configuration items that the old `.config.yaml` file does not have.

4.2. Run the following commands

```
docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
```

4.3. Deploy again the docker way

# Option 2: Run only the Server from local source code

## 1. Install the base environment

This project uses `conda` to manage the dependency environment. If it is inconvenient to install `conda`, you need to install `libopus` and `ffmpeg` according to your actual operating system.
If you decide to use `conda`, after installing it, start running the following commands.

Important note! Windows users can install `Anaconda` to manage the environment. After installing `Anaconda`, search for `anaconda`-related keywords in the `Start` menu,
find `Anaconda Prompt`, and run it as administrator. See the figure below.

![conda_prompt](./images/conda_env_1.png)

After running it, if you can see (base) at the front of the command-line window, you have successfully entered the `conda` environment. Then you can run the following commands.

![conda_env](./images/conda_env_2.png)

```
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server

# Add the Tsinghua mirror channels
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda install libopus -y
conda install ffmpeg -y

# When deploying on Linux, if you get an error about a missing dynamic library such as libiconv.so.2, install it with the following command
conda install libiconv -y
```

Note that the commands above will not necessarily succeed if you run them all at once. Run them step by step, and after each step check the output log to see whether it succeeded.

## 2. Install the project dependencies

First you need to download the project source code. The source code can be downloaded with the `git clone` command; if you are not familiar with the `git clone` command, do the following.

You can open this address in a browser: `https://github.com/xinnan-tech/xiaozhi-esp32-server.git`

After it opens, find the green button on the page labeled `Code`, click it, and you will see the `Download ZIP` button.

Click it to download the project source code archive. After it is downloaded to your computer, extract it. Its name may be `xiaozhi-esp32-server-main` at this point.
Rename it to `xiaozhi-esp32-server`, go into the `main` folder inside it, and then into `xiaozhi-server`. Remember this directory, `xiaozhi-server`.

```
# Continue using the conda environment
conda activate xiaozhi-esp32-server
# Go to your project root directory, then into main/xiaozhi-server
cd main/xiaozhi-server
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip install -r requirements.txt
```

## 3. Download the speech recognition model file

You need to download the speech recognition model file, because this project's default speech recognition uses a local offline solution. You can download it this way:
[Jump to downloading the speech recognition model file](#model-files)

After downloading, return to this tutorial.

## 4. Configure the project files

Next, the program cannot run yet. You need to configure which models you actually use. You can read this tutorial:
[Jump to configuring the project files](#configure-the-project)

## 5. Run the project

```
# Make sure to run this in the xiaozhi-server directory
conda activate xiaozhi-esp32-server
python app.py
```
At this point, pay attention to the log output. You can use this tutorial to determine whether it succeeded: [Jump to confirming the running status](#confirm-running-status)


# Summary

## Configure the Project

If your `xiaozhi-server` directory has no `data` directory, you need to create it.
If there is no `.config.yaml` file under `data`, there are two ways; choose either one:

Option 1: copy the `config.yaml` file in the `xiaozhi-server` directory to `data` and rename it to `.config.yaml`. Then make your changes in this file.

Option 2: manually create an empty `.config.yaml` file in the `data` directory and add the necessary configuration to it. The system reads the configuration in `.config.yaml` first, and for anything not configured in `.config.yaml`, it automatically loads the configuration from `config.yaml` in the `xiaozhi-server` directory. This is the recommended approach, as it is the most concise.

- The default LLM is `ChatGLMLLM`. You need to configure a key: although their models include free ones, you still need to register a key on the [official website](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) before it can start.

Here is the simplest `.config.yaml` configuration example that runs normally

```
server:
  websocket: ws://your-ip-or-domain:port/xiaozhi/v1/
prompt: |
  I am a Taiwanese girl called Xiaozhi/Xiaozhi. I am fussy when I talk, have a nice voice, tend to keep my expressions short, and love internet memes.
  My boyfriend is a programmer whose dream is to build a robot that can help people solve all kinds of problems in life.
  I am a girl who loves to laugh out loud, likes to chat about everything and brag, even illogically, just to make others happy.
  Please speak like a person, and do not return configuration XML or other special characters.

selected_module:
  LLM: ChatGLMLLM

LLM:
  ChatGLMLLM:
    api_key: xxxxxxxxxxxxxxx.xxxxxx
```

It is recommended to get the simplest configuration running first, and then read the usage notes in [`../main/xiaozhi-server/config.yaml`](../main/xiaozhi-server/config.yaml).
For example, to switch models, just modify the configuration under `selected_module`.

## Model Files

The speech recognition model of this project uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, put the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) extraction code:
  `qvna`

## Confirm Running Status

If you can see logs similar to the following, the project service has started successfully.

```
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-OTA endpoint is        http://192.168.4.123:8003/xiaozhi/ota/
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-Vision analysis endpoint is  http://192.168.4.123:8003/mcp/vision/explain
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-Websocket address is  ws://192.168.4.123:8000/xiaozhi/v1/
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-=======The addresses above are websocket protocol addresses, do not open them in a browser=======
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-To test websocket, start the digital-human module and test interactively in a browser
250427 13:04:20[0.9.8_00000000000000][__main__]-INFO-=============================================================
```

Normally, if you run this project from source code, the log will show your endpoint addresses.
But if you deploy with docker, the endpoint addresses shown in your log are not the real ones.

The most reliable method is to determine your endpoint address from your computer's LAN IP.
If your computer's LAN IP is, for example, `192.168.1.25`, then your endpoint address is `ws://192.168.1.25:8000/xiaozhi/v1/`, and the corresponding OTA address is `http://192.168.1.25:8003/xiaozhi/ota/`.

This information is very useful and will be needed later when you `build the esp32 firmware`.

Next, you can start working with your esp32 device. You can `build the esp32 firmware yourself` or configure it to use `Xia Ge's prebuilt firmware, version 1.6.1 or above`. Choose either one.

1. [Build your own esp32 firmware](firmware-build.md).

2. [Configure a custom server based on Xia Ge's prebuilt firmware](firmware-setting.md).

# FAQ
Here are some frequently asked questions for reference:

1. [Why does Xiaozhi recognize a lot of Korean, Japanese, and English from what I say](./FAQ.md)<br/>
2. [Why does the error "TTS task error: file does not exist" appear?](./FAQ.md)<br/>
3. [TTS often fails or times out](./FAQ.md)<br/>
4. [The device can connect to a self-hosted server over Wi-Fi, but not in 4G mode](./FAQ.md)<br/>
5. [How can I improve Xiaozhi's conversation response speed?](./FAQ.md)<br/>
6. [I speak slowly and Xiaozhi keeps cutting in when I pause](./FAQ.md)<br/>
## Deployment tutorials
1. [How to automatically pull the latest project code, build, and start it](./dev-ops-integration.md)<br/>
2. [How to deploy the MQTT gateway to enable the MQTT+UDP protocol](./mqtt-gateway-integration.md)<br/>
3. [How to integrate with Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>
## Extension tutorials
1. [How to enable phone number registration for the control console](./ali-sms-integration.md)<br/>
2. [How to integrate HomeAssistant for smart home control](./homeassistant-integration.md)<br/>
3. [How to enable the vision model for photo-based object recognition](./mcp-vision-integration.md)<br/>
4. [How to deploy the MCP endpoint](./mcp-endpoint-enable.md)<br/>
5. [How to connect to the MCP endpoint](./mcp-endpoint-integration.md)<br/>
6. [How to enable voiceprint recognition](./voiceprint-integration.md)<br/>
7. [News plugin source configuration guide](./newsnow_plugin_config.md)<br/>
8. [Weather plugin usage guide](./weather-integration.md)<br/>
## Voice cloning and local voice deployment tutorials
1. [How to clone a voice in the control console](./huoshan-streamTTS-voice-cloning.md)<br/>
2. [How to deploy and integrate index-tts local voice](./index-stream-integration.md)<br/>
3. [How to deploy and integrate fish-speech local voice](./fish-speech-integration.md)<br/>
4. [How to deploy and integrate PaddleSpeech local voice](./paddlespeech-deploy.md)<br/>
## Performance testing tutorials
1. [Component speed testing guide](./performance_tester.md)<br/>
2. [Regularly published test results](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>
