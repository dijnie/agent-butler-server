Log in to AutoDL and rent an image
Choose the image:
```
PyTorch / 2.1.0 / 3.10(ubuntu22.04) / cuda 12.1
```

After the machine boots, set up academic acceleration
```
source /etc/network_turbo
```

Enter the working directory
```
cd autodl-tmp/
```

Pull the project
```
git clone https://gitclone.com/github.com/fishaudio/fish-speech.git ; cd fish-speech
```

Install dependencies
```
pip install -e.
```

If it reports an error, install portaudio
```
apt-get install portaudio19-dev -y
```

Run after installing
```
pip install torch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 --index-url https://download.pytorch.org/whl/cu121
```

Download the models
```
cd tools
python download_models.py 
```

After downloading the models, run the API
```
python -m tools.api_server --listen 0.0.0.0:6006 
```

Then use a browser to go to the AutoDL instance page
```
https://autodl.com/console/instance/list
```

As shown in the figure below, click the `Custom Service` button of the machine you just created to enable port forwarding
![Custom service](images/fishspeech/autodl-01.png)

After the port forwarding service is set up, open `http://localhost:6006/` on your local computer to access the fish-speech API
![Service preview](images/fishspeech/autodl-02.png)


If you use the single-module deployment, the core configuration is as follows
```
selected_module:
  TTS: FishSpeech
TTS:
  FishSpeech:
    reference_audio: ["config/assets/wakeup_words.wav",]
    reference_text: ["哈啰啊，我是小智啦，声音好听的台湾女孩一枚，超开心认识你耶，最近在忙啥，别忘了给我来点有趣的料哦，我超爱听八卦的啦",]
    api_key: "123"
    api_url: "http://127.0.0.1:6006/v1/tts"
```

Then restart the service