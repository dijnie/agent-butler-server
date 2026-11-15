# Deployment Architecture Diagram
![See the full-module installation architecture diagram](../docs/images/deploy2.png)
# Option 1: Run all modules with Docker
Starting from version `0.8.2`, the docker images released by this project only support the `x86 architecture`. To deploy on an `arm64 architecture` CPU, follow [this tutorial](docker-build.md) to build the `arm64 image` locally.

## 1. Install docker

If docker is not installed on your computer yet, you can install it by following this tutorial: [docker installation](https://www.runoob.com/docker/ubuntu-docker-install.html)

There are two ways to install all modules with docker. You can [use the one-click script](./Deployment_all.md#11-one-click-script) (author: [@VanillaNahida](https://github.com/VanillaNahida))  
The script automatically downloads the required files and configuration files for you. Alternatively, you can use [manual deployment](./Deployment_all.md#12-manual-deployment) to set everything up from scratch.



### 1.1 One-click script
Deployment is simple. You can refer to the [video tutorial](https://www.bilibili.com/video/BV17bbvzHExd/). The written tutorial is as follows:
> [!NOTE]  
> For now, one-click deployment only supports Ubuntu servers. Other systems have not been tried and may have some strange bugs

Connect to the server with an SSH tool and run the following script with root privileges
```bash
sudo bash -c "$(wget -qO- https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/main/docker-setup.sh)"
```

The script automatically completes the following operations:
> 1. Install Docker
> 2. Configure the image mirror
> 3. Download/pull the images
> 4. Download the speech recognition model file
> 5. Guide you through configuring the server
>

After it finishes and you complete the simple configuration, follow the 3 most important things mentioned in [4. Run the program](#4-run-the-program) and [5. Restart xiaozhi-esp32-server](#5-restart-xiaozhi-esp32-server). Once these three items are configured, you can start using it.

### 1.2 Manual deployment

#### 1.2.1 Create the directories

After installation, you need to find a directory for this project's configuration files. For example, we can create a folder called `xiaozhi-server`.

After creating the directory, create a `data` folder and a `models` folder under `xiaozhi-server`, and then create a `SenseVoiceSmall` folder under `models`.

The final directory structure is as follows:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.2.2 Download the speech recognition model file

The speech recognition model of this project uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, put the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) extraction code:
  `qvna`


#### 1.2.3 Download the configuration files

You need to download two configuration files: `docker-compose_all.yaml` and `config_from_api.yaml`. Both files are downloaded from the project repository.

##### 1.2.3.1 Download docker-compose_all.yaml

Open [this link](../main/xiaozhi-server/docker-compose_all.yml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon and click it to download the `docker-compose_all.yml` file. Download the file into your
`xiaozhi-server`.

Or run directly `wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/docker-compose_all.yml` to download.

After downloading, return to this tutorial and continue.

##### 1.2.3.2 Download config_from_api.yaml

Open [this link](../main/xiaozhi-server/config_from_api.yaml) in a browser.

On the right side of the page, find the button named `RAW`. Next to the `RAW` button, find the download icon and click it to download the `config_from_api.yaml` file. Download the file into the `data` folder under your
`xiaozhi-server`, then rename the `config_from_api.yaml` file to `.config.yaml`.

Or run directly `wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/config_from_api.yaml` to download and save.

After downloading the configuration files, let's confirm that the files in `xiaozhi-server` look like this:

```
xiaozhi-server
  ├─ docker-compose_all.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

If your directory structure matches the one above, continue. If not, look carefully again to see whether you missed a step.

## 2. Back up your data

If you have previously run the control console successfully and it holds your key information, first copy the important data from the control console. The upgrade process may overwrite the original data.

## 3. Remove old-version images and containers
Next, open a command-line tool (`Terminal` or `Command Prompt`), go to your `xiaozhi-server`, and run the following commands

```
docker compose -f docker-compose_all.yml down

docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server

docker stop xiaozhi-esp32-server-web
docker rm xiaozhi-esp32-server-web

docker stop xiaozhi-esp32-server-db
docker rm xiaozhi-esp32-server-db

docker stop xiaozhi-esp32-server-redis
docker rm xiaozhi-esp32-server-redis

docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest
```

## 4. Run the program
Run the following command to start the new-version containers

```
docker compose -f docker-compose_all.yml up -d
```

After that, run the following command to view the logs.

```
docker logs -f xiaozhi-esp32-server-web
```

When you see this log output, your `control console` has started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

Note that at this point only the `control console` is able to run. If `xiaozhi-esp32-server` on port 8000 reports an error, ignore it for now.

At this point, use a browser to open the `control console` at http://127.0.0.1:8002 and register the first user. The first user is the super administrator, and later users are regular users. Regular users can only bind devices and configure agents; the super administrator can manage models, manage users, configure parameters, and more.

Next, there are three important things to do:

### The first important thing

Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the first entry in the list whose Parameter Code is `server.secret`, and copy its `Parameter Value`.

`server.secret` needs some explanation. This `Parameter Value` is very important: it lets our `Server` connect to `manager-api`. `server.secret` is a key that is randomly generated automatically each time the manager module is deployed from scratch.

After copying the `Parameter Value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file should look like this:

```
manager-api:
  url:  http://127.0.0.1:8002/xiaozhi
  secret: your-server.secret-value
```
1. Copy the `Parameter Value` of `server.secret` that you just copied from the `control console` into `secret` in the `.config.yaml` file.

2. Because you deployed with docker, change the `url` to the following `http://xiaozhi-esp32-server-web:8002/xiaozhi`

3. Because you deployed with docker, change the `url` to the following `http://xiaozhi-esp32-server-web:8002/xiaozhi`

4. Because you deployed with docker, change the `url` to the following `http://xiaozhi-esp32-server-web:8002/xiaozhi`

The result should look something like this
```
manager-api:
  url: http://xiaozhi-esp32-server-web:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

After saving, continue with the second important thing

### The second important thing

Log in to the control console with the super administrator account, find `Models` in the top menu, click `Large Language Model` in the left sidebar, find the first entry `Zhipu AI`, and click the `Edit` button.
In the dialog that pops up, enter the key you registered for `Zhipu AI` into `API Key`. Then click Save.

## 5. Restart xiaozhi-esp32-server

Next, open a command-line tool (`Terminal` or `Command Prompt`) and enter
```
docker restart xiaozhi-esp32-server
docker logs -f xiaozhi-esp32-server
```
If you can see logs similar to the following, the Server has started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - Websocket address is  ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The addresses above are websocket protocol addresses, do not open them in a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - To test websocket, start the digital-human module and test interactively in a browser
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Because you deployed all modules, you have two important endpoints that need to be written into the esp32.

OTA endpoint:
```
http://your-host-LAN-ip:8002/xiaozhi/ota/
```

Websocket endpoint:
```
ws://your-host-ip:8000/xiaozhi/v1/
```

### The third important thing

Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the parameter whose Parameter Code is `server.websocket`, and enter your `Websocket endpoint`.

Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the parameter whose Parameter Code is `server.ota`, and enter your `OTA endpoint`.

Next, you can start working with your esp32 device. You can `build the esp32 firmware yourself` or configure it to use `Xia Ge's prebuilt firmware, version 1.6.1 or above`. Choose either one.

1. [Build your own esp32 firmware](firmware-build.md).

2. [Configure a custom server based on Xia Ge's prebuilt firmware](firmware-setting.md).


# Option 2: Run all modules from local source code

## 1. Install the MySQL database

If MySQL is already installed on this machine, you can directly create a database named `xiaozhi_esp32_server` in it.

```sql
CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

If you do not have MySQL yet, you can install mysql with docker

```
docker run --name xiaozhi-esp32-server-db -e MYSQL_ROOT_PASSWORD=123456 -p 3306:3306 -e MYSQL_DATABASE=xiaozhi_esp32_server -e MYSQL_INITDB_ARGS="--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci" -e TZ=Asia/Shanghai -d mysql:latest
```

## 2. Install redis

If you do not have Redis yet, you can install redis with docker

```
docker run --name xiaozhi-esp32-server-redis -d -p 6379:6379 redis
```

## 3. Run the manager-api program

3.1 Install JDK 21 and set the JDK environment variable

3.2 Install Maven and set the Maven environment variable

3.3 Use the VS Code editor and install the Java environment-related plugins

3.4 Load the manager-api module with VS Code

Configure the database connection information in `src/main/resources/application-dev.yml`

```
spring:
  datasource:
    username: root
    password: 123456
```
Configure the Redis connection information in `src/main/resources/application-dev.yml`
```
spring:
    data:
      redis:
        host: localhost
        port: 6379
        password:
        database: 0
```

3.5 Run the main program

This project is a SpringBoot project. To start it:
open `Application.java` and run the `Main` method

```
Path:
src/main/java/xiaozhi/AdminApplication.java
```

When you see this log output, your `manager-api` has started successfully.

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

## 4. Run the manager-web program

4.1 Install nodejs

4.2 Load the manager-web module with VS Code

In a terminal, go to the manager-web directory

```
npm install
```
Then start it
```
npm run serve
```

Note that if your manager-api endpoint is not at `http://localhost:8002`, change the path in
`main/manager-web/.env.development` during development

After it runs successfully, use a browser to open the `control console` at http://127.0.0.1:8001 and register the first user. The first user is the super administrator, and later users are regular users. Regular users can only bind devices and configure agents; the super administrator can manage models, manage users, configure parameters, and more.


Important: after registering successfully, log in to the control console with the super administrator account, find `Models` in the top menu, click `Large Language Model` in the left sidebar, find the first entry `Zhipu AI`, and click the `Edit` button.
In the dialog that pops up, enter the key you registered for `Zhipu AI` into `API Key`. Then click Save.

Important: after registering successfully, log in to the control console with the super administrator account, find `Models` in the top menu, click `Large Language Model` in the left sidebar, find the first entry `Zhipu AI`, and click the `Edit` button.
In the dialog that pops up, enter the key you registered for `Zhipu AI` into `API Key`. Then click Save.

Important: after registering successfully, log in to the control console with the super administrator account, find `Models` in the top menu, click `Large Language Model` in the left sidebar, find the first entry `Zhipu AI`, and click the `Edit` button.
In the dialog that pops up, enter the key you registered for `Zhipu AI` into `API Key`. Then click Save.

## 5. Install the Python environment

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

## 6. Install the project dependencies

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

### 7. Download the speech recognition model file

The speech recognition model of this project uses the `SenseVoiceSmall` model by default for speech-to-text. Because the model is large, it needs to be downloaded separately. After downloading, put the `model.pt`
file in the `models/SenseVoiceSmall`
directory. Choose either of the two download routes below.

- Route 1: download from Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Route 2: download from Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) extraction code:
  `qvna`

## 8. Configure the project files

Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the first entry in the list whose Parameter Code is `server.secret`, and copy its `Parameter Value`.

`server.secret` needs some explanation. This `Parameter Value` is very important: it lets our `Server` connect to `manager-api`. `server.secret` is a key that is randomly generated automatically each time the manager module is deployed from scratch.

If your `xiaozhi-server` directory has no `data` directory, you need to create it.
If there is no `.config.yaml` file under `data`, you can copy the `config_from_api.yaml` file in the `xiaozhi-server` directory to `data` and rename it to `.config.yaml`

After copying the `Parameter Value`, open the `.config.yaml` file in the `data` directory under `xiaozhi-server`. At this point your configuration file should look like this:

```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: your-server.secret-value
```

Copy the `Parameter Value` of `server.secret` that you just copied from the `control console` into `secret` in the `.config.yaml` file.

The result should look something like this
```
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

## 9. Run the project

```
# Make sure to run this in the xiaozhi-server directory
conda activate xiaozhi-esp32-server
python app.py
```

If you can see logs similar to the following, the project service has started successfully.

```
25-02-23 12:01:09[core.websocket_server] - INFO - Server is running at ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======The addresses above are websocket protocol addresses, do not open them in a browser=======
25-02-23 12:01:09[core.websocket_server] - INFO - To test websocket, start the digital-human module and test interactively in a browser
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Because you deployed all modules, you have two important endpoints.

OTA endpoint:
```
http://your-computer-LAN-ip:8002/xiaozhi/ota/
```

Websocket endpoint:
```
ws://your-computer-LAN-ip:8000/xiaozhi/v1/
```

Be sure to write the two endpoint addresses above into the control console: they affect the websocket address distribution and the automatic upgrade feature.

1. Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the parameter whose Parameter Code is `server.websocket`, and enter your `Websocket endpoint`.

2. Log in to the control console with the super administrator account, find `Params Management` under `More` in the top menu, find the parameter whose Parameter Code is `server.ota`, and enter your `OTA endpoint`.


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
