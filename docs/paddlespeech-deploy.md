# Integrating PaddleSpeechTTS with the Xiaozhi Service

## Key points
- Advantages: local offline deployment, fast
- Disadvantages: as of September 25, 2025, the default model is a Chinese model and does not support English text-to-speech. Text containing English produces no sound. To support both Chinese and English you need to train your own model.

## 1. Base environment requirements
Operating system: Windows / Linux / WSL 2

Python version: 3.9 or later (adjust per the official Paddle tutorial)

Paddle version: the latest official version   ```https://www.paddlepaddle.org.cn/install```

Dependency management tool: conda or venv

## 2. Start the paddlespeech service
### 1. Pull the source code from the official paddlespeech repository
```bash 
git clone https://github.com/PaddlePaddle/PaddleSpeech.git
```
### 2. Create a virtual environment
```bash

conda create -n paddle_env python=3.10 -y
conda activate paddle_env
```
### 3. Install paddle
The CPU and GPU architectures differ, so create the environment according to the Python versions officially supported by Paddle    
```
https://www.paddlepaddle.org.cn/install
```

### 4. Enter the paddlespeech directory
```bash
cd PaddleSpeech
```
### 5. Install paddlespeech
```bash
pip install pytest-runner -i https://pypi.tuna.tsinghua.edu.cn/simple

#Use any one of the following commands
pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
pip install paddlespeech -i https://pypi.tuna.tsinghua.edu.cn/simple
```
### 6. Download the speech models automatically with a command
```bash
paddlespeech tts --input "你好，这是一次测试"
```
This step automatically downloads the models and caches them in the local .paddlespeech/models directory

### 7. Edit the tts_online_application.yaml configuration
Reference path ```"PaddleSpeech\demos\streaming_tts_server\conf\tts_online_application.yaml"```
On Linux / WSL 2 use forward slashes: ```"PaddleSpeech/demos/streaming_tts_server/conf/tts_online_application.yaml"```
Open the ```tts_online_application.yaml``` file in an editor and set ```protocol``` to ```websocket```

### 8. Start the service
```bash
paddlespeech_server start --config_file ./demos/streaming_tts_server/conf/tts_online_application.yaml
#Official default start command:
paddlespeech_server start --config_file ./conf/tts_online_application.yaml
```
Start the command according to the actual directory of your ```tts_online_application.yaml```. When you see the following log, the service has started successfully
```
Prefix dict has been built successfully.
[2025-08-07 10:03:11,312] [   DEBUG] __init__.py:166 - Prefix dict has been built successfully.
INFO:     Started server process [2298]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8092 (Press CTRL+C to quit)
```

## 3. Configure the Xiaozhi service
### 1. No code changes needed (the provider is built in at main/xiaozhi-server/core/providers/tts/paddle_speech.py)

### 2. Create `main/xiaozhi-server/data/.config.yaml`

The `main/xiaozhi-server/data/` directory is not in the repository; it is ignored by `.gitignore`, so the first time you must create it, and then create a `.config.yaml` file inside it (run this from the repository root; after the `cd PaddleSpeech` above, the current directory is still the PaddleSpeech source directory):

```bash
mkdir -p main/xiaozhi-server/data
```

This file is required. Without it the Xiaozhi service cannot start and exits with an error.

Using the single-module deployment
```yaml
selected_module:
  TTS: PaddleSpeechTTS
TTS:
  PaddleSpeechTTS:
      type: paddle_speech
      protocol: websocket  # Currently only websocket is supported
      url:  ws://127.0.0.1:8092/paddlespeech/tts/streaming  # URL of the TTS service, pointing to the local server [websocket default ws://127.0.0.1:8092/paddlespeech/tts/streaming]
      spk_id: 0  # Speaker ID, 0 usually means the default speaker
      speed: 1.0  # Speech rate, 1.0 means normal speed, >1 faster, <1 slower
      volume: 1.0  # Volume, 1.0 means normal volume, >1 louder, <1 quieter
      save_path:   # Save path
```
The sample rate is fixed at 24000 and hard-coded inside the provider, so you do not need to set it in the configuration.

### 3. Start the xiaozhi service

The Xiaozhi service uses **another** Python environment. Do not use the `paddle_env` you created earlier for PaddleSpeech: that environment has PaddleSpeech's own dependencies, whose versions it decides, and they may not match the versions this project pins (`paddlespeech` sets no upper bound for numpy, so the numpy installed there may not be the one this project needs). The Python version and dependency versions recommended by this project are written in `main/xiaozhi-server/requirements.txt` (the top of the file recommends python3.10, and it also pins torch 2.2.2 and numpy 1.26.4).

First create the environment and install the dependencies (run from the repository root):
```bash
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server
cd main/xiaozhi-server
pip install -r requirements.txt
```

Then start it from the `main/xiaozhi-server` directory (you cannot change directory: the provider is found by the relative path `core/providers/tts/`, see `core/utils/tts.py:35`):
```bash
# The previous block already did cd to main/xiaozhi-server, so no need to cd again here
# If this is a newly opened terminal, first cd main/xiaozhi-server and then run it
python app.py
```

To verify the actual speech synthesis output, open another terminal and run the digital human page from the repository root (this code has its own dependency list in `main/digital-human/wakeword_runtime/requirements.txt`, and a missing package will be reported; the wake word part also needs numpy: `core/detector.py:7` and `core/microphone.py:4` import numpy at module top level. If you run with the `xiaozhi-esp32-server` environment created above, numpy is already in it, so there is no problem):
```bash
cd main/digital-human
python start.py
```

Open `http://127.0.0.1:8006/index.html`, and check whether the paddlespeech side prints logs when you test the connection and send messages

Reference output log:
```
INFO:     127.0.0.1:44312 - "WebSocket /paddlespeech/tts/streaming" [accepted]
INFO:     connection open
[2025-08-07 11:16:33,355] [    INFO] - sentence: 哈哈，怎么突然找我聊天啦？
[2025-08-07 11:16:33,356] [    INFO] - The durations of audio is: 2.4625 s
[2025-08-07 11:16:33,356] [    INFO] - first response time: 0.1143045425415039 s
[2025-08-07 11:16:33,356] [    INFO] - final response time: 0.4777836799621582 s
[2025-08-07 11:16:33,356] [    INFO] - RTF: 0.19402382942625715
[2025-08-07 11:16:33,356] [    INFO] - Other info: front time: 0.06514096260070801 s, first am infer time: 0.008037090301513672 s, first voc infer time: 0.04112648963928223 s,
[2025-08-07 11:16:33,356] [    INFO] - Complete the synthesis of the audio streams
INFO:     connection closed

```
