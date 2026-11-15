# Usage Guide for the Performance Test Tool for Speech Recognition, Streaming Speech Recognition, Large Language Models, Non-Streaming Speech Synthesis, Streaming Speech Synthesis, and Vision Models

0. Install the dependencies first (run from the repository root)
```
cd main/xiaozhi-server
pip install -r requirements.txt
```
The test script imports `yaml`, `aiohttp`, and `tabulate`, and it will not start if any one is missing. `tabulate` is not in requirements.txt; it is pulled in indirectly by `edge-tts`.

1. Create a data directory in the main/xiaozhi-server directory
2. Create a .config.yaml file in the data directory
3. In data/.config.yaml, write the parameters for your speech recognition, streaming speech recognition, large language model, non-streaming speech synthesis, streaming speech synthesis, and vision model
For example:
```
LLM:
  ChatGLMLLM:
    # Define the LLM API type
    type: openai
    # glm-4-flash is free, but you still need to register and fill in an api_key
    # You can find your api key here https://bigmodel.cn/usercenter/proj-mgmt/apikeys
    model_name: glm-4-flash
    url: https://open.bigmodel.cn/api/paas/v4/
    api_key: your chat-glm web key

TTS:
  EdgeTTS:
    # Define the TTS API type
    type: edge
    voice: zh-CN-XiaoxiaoNeural

VLLM:
  ChatGLMVLLM:
    # Define the vision model API type
    type: openai
    # glm-4v-flash is Zhipu's vision model; you need to apply for an api_key on the Zhipu platform
    model_name: glm-4v-flash
    url: https://open.bigmodel.cn/api/paas/v4/
    api_key: your api_key

ASR:
  FunASR:
    type: fun_local
    model_dir: models/SenseVoiceSmall
    language: auto
```
4. Run performance_tester.py in the main/xiaozhi-server directory:  
```
python performance_tester.py
```

## Notes

- The `docs/performance_tester.md` mentioned in the first line of the script's output is this document, which is under `docs/` in the repository root; the script itself runs from the `main/xiaozhi-server/` directory, so the two are not in the same directory.
- For LLM, VLLM, and non-streaming speech synthesis, the script merges `config.yaml` and `data/.config.yaml` and then iterates over the result, so it actually tests **every provider that has an api_key configured**, not only the one you wrote in `.config.yaml`; providers whose api_key is still a placeholder are skipped.
- Non-streaming speech recognition reads its configuration differently from the others: it scans `*.config.yaml` files under the `data/` directory itself and takes only their `ASR` section; it does **not** use the defaults in `config.yaml`. To test speech recognition, you must write the provider into `data/.config.yaml`.
- Streaming speech recognition reads the merged configuration and always tests these three: `DoubaoStreamASR`, `Qwen3ASRFlash`, and `XunfeiStreamASR`. The keys for these three in `config.yaml` are placeholders; you must fill in your own keys in the `ASR` section of `data/.config.yaml` for latency to be measured.
- The vision model configuration goes in the `VLLM:` section of `data/.config.yaml`. This section **must not be just an empty key**: if it is empty, the whole merged section is empty, and this test is skipped and tests nothing.
- Streaming speech synthesis runs these providers in one pass:

| Provider | Description |
|---|---|
| `AliyunStreamTTS` | Alibaba Cloud streaming TTS, called unconditionally |
| `HuoshanDoubleStreamTTS` | Volcano Engine streaming TTS, called unconditionally |
| `PaddleSpeechTTS` | PaddleSpeech streaming TTS, called unconditionally |
| `IndexStreamTTS` | IndexStream streaming TTS, called unconditionally |
| `LinkeraiTTS` | The TTS section of `config.yaml` does not contain this provider, so it is not tested by default and the whole item is skipped; to test it, add it yourself in `.config.yaml` |
| `AliBLTTS` | Alibaba Bailian streaming TTS, tested by default: the check reads the merged configuration, and `config.yaml` already contains this item |
| `XunFeiTTS` | iFlytek streaming TTS, same as above, tested by default |

The default keys for `AliBLTTS` and `XunFeiTTS` are placeholders, so unless you replace them with your own keys in `.config.yaml` they report failure. To skip them, write both in `.config.yaml` as empty (leave nothing under the key name).

For the ones marked "called unconditionally" (`AliyunStreamTTS`, `HuoshanDoubleStreamTTS`, `PaddleSpeechTTS`, `IndexStreamTTS`), if the provider is missing or cleared, that item raises an error, which is swallowed by the exception handling inside the test method and the item is recorded as a failure: an extra failure row appears in the results table, but it does not affect the other items. The ones with a guard (`AliBLTTS`, `XunFeiTTS`, `LinkeraiTTS`) are skipped entirely: if not configured, there is no error and no row in the results table either.
