# Starting the Digital Human (digital-human)

## Overview

The test page integrates high-accuracy voice wake-up based on **Sherpa-ONNX**, with custom wake words and real-time detection. It uses a lightweight keyword spotting model and responds within milliseconds.

## Wake Word Model

### Model Download (required)

**Important**: The project does not include the model files. Download and configure them in advance.

### Official Model Download

- **Official model list**: <https://csukuangfj.github.io/sherpa/onnx/kws/pretrained_models/index.html>
- **Recommended model**: `sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01`

### Download and Setup Steps

#### 1. Download the model package

```bash
# Method 1: direct download (recommended)
cd main/digital-human/wakeword_runtime/
wget https://github.com/k2-fsa/sherpa-onnx/releases/download/kws-models/sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01.tar.bz2

# Extract
tar xvf sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01.tar.bz2

# Method 2: use ModelScope
pip install modelscope
python -c "
from modelscope import snapshot_download
snapshot_download('pkufool/sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01', cache_dir='./models')
"
```

#### 2. Set up the model files

The downloaded model package contains the following files:

```
sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01/
├── encoder-epoch-12-avg-2-chunk-16-left-64.int8.onnx    # speed first
├── encoder-epoch-12-avg-2-chunk-16-left-64.onnx
├── encoder-epoch-99-avg-1-chunk-16-left-64.int8.onnx    # speed first
├── encoder-epoch-99-avg-1-chunk-16-left-64.onnx         # accuracy first
├── decoder-epoch-12-avg-2-chunk-16-left-64.onnx
├── decoder-epoch-99-avg-1-chunk-16-left-64.onnx         # accuracy first
├── joiner-epoch-12-avg-2-chunk-16-left-64.int8.onnx     # speed first
├── joiner-epoch-12-avg-2-chunk-16-left-64.onnx
├── joiner-epoch-99-avg-1-chunk-16-left-64.int8.onnx     # speed first
├── joiner-epoch-99-avg-1-chunk-16-left-64.onnx          # accuracy first
├── tokens.txt                    # Token mapping table (required)
├── keywords_raw.txt              # May ship in the model package (optional, not required by the runtime)
├── keywords.txt                  # Ready-made
├── test_wavs/                    # Test audio (optional)
├── configuration.json            # Model metadata (optional)
└── README.md                     # Documentation (optional)
```

#### 3. Choose a setup

**Option 1: accuracy first (recommended)**

```bash
cd sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01

# Create the model directory
mkdir -p ../models

# Copy the accuracy-first epoch-99 fp32 trio
cp encoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/encoder.onnx
cp decoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/decoder.onnx
cp joiner-epoch-99-avg-1-chunk-16-left-64.onnx ../models/joiner.onnx

# Copy the supporting files
cp tokens.txt ../models/tokens.txt
# If keywords_raw.txt ships in the model package you may keep it; the runtime does not need it
```

**Option 2: speed first**

```bash
cd sherpa-onnx-kws-zipformer-wenetspeech-3.3M-2024-01-01

# Create the model directory
mkdir -p ../models

# Copy the speed-first epoch-99 int8 trio
cp encoder-epoch-99-avg-1-chunk-16-left-64.int8.onnx ../models/encoder.onnx
cp decoder-epoch-99-avg-1-chunk-16-left-64.onnx ../models/decoder.onnx
cp joiner-epoch-99-avg-1-chunk-16-left-64.int8.onnx ../models/joiner.onnx

# Copy the supporting files
cp tokens.txt ../models/tokens.txt
```

**Notes**:

- **Do not mix fp32 and int8**: the three model files must use the same precision
- **Prefer epoch-99**: it is trained more thoroughly than epoch-12 and is more accurate
- **Required files**: `encoder.onnx` + `decoder.onnx` + `joiner.onnx` + `tokens.txt` + `keywords.txt`

### Final Model File Layout

After setup, the model files should be in the `wakeword_runtime/models/` directory, with the full path `main/digital-human/wakeword_runtime/models/`:

```
wakeword_runtime/models/
├── encoder.onnx      # Encoder model (after renaming)
├── decoder.onnx      # Decoder model (after renaming)
├── joiner.onnx       # Joiner model (after renaming)
├── tokens.txt        # Pinyin token mapping table (228-line version)
├── keywords.txt      # Keyword configuration file (generated automatically on first start)
└── keywords_raw.txt  # Optional, not required by the runtime
```

## Starting

Run in the `main/digital-human` directory:

```bash
pip install -r wakeword_runtime/requirements.txt
python start.py
```

Default addresses after startup:

- Page: `http://127.0.0.1:8006/index.html`
- Event bridge: `ws://127.0.0.1:8006/wakeword-ws`
- Health check: `http://127.0.0.1:8006/health`

To stop:

- Press `Ctrl+C` in the terminal where it is running
- This stops the static page service, the event bridge, and the wake word detection process together

## Configuration File

The configuration file is at [main/digital-human/wakeword_runtime/config.json](../main/digital-human/wakeword_runtime/config.json).

Main configuration items:

```json
{
  "wakeword": {
    "enabled": true
  },
  "model_dir": "models",
  "audio": {
    "input_device": null,
    "sample_rate": 16000,
    "channels": 1
  },
  "detector": {
    "num_threads": 4,
    "provider": "cpu",
    "max_active_paths": 2,
    "keywords_score": 1.8,
    "keywords_threshold": 0.1,
    "num_trailing_blanks": 1,
    "cooldown_seconds": 1.5
  },
  "logging": {
    "level": "INFO",
    "dir": "logs",
    "file": "wakeword-runtime.log"
  }
}
```

Field meanings:

| Parameter | Description |
| --- | --- |
| `wakeword.enabled` | Whether to enable local wake word detection |
| `model_dir` | Directory containing the model and vocabulary |
| `audio.input_device` | Microphone input device; the system default device is used by default |
| `audio.sample_rate` | Sample rate, default `16000` |
| `audio.channels` | Number of channels, default `1` |
| `detector.num_threads` | Number of detector threads |
| `detector.provider` | Inference provider, normally `cpu` at present |
| `detector.max_active_paths` | Number of search paths |
| `detector.keywords_score` | Keyword boosting score |
| `detector.keywords_threshold` | Detection threshold |
| `detector.num_trailing_blanks` | Number of trailing blanks |
| `detector.cooldown_seconds` | Cooldown time between consecutive triggers |
| `logging.level` | Log level |
| `logging.dir` | Log directory |
| `logging.file` | Log file name |

## Recommended Workflow

### First Use

1. Prepare the model files and `tokens.txt` in the `models/` directory
2. Confirm that `models/keywords.txt` exists
3. Run `python start.py` in the `digital-human` directory
4. Open `http://127.0.0.1:8006/index.html`
5. Go to the settings page and check the "Wake Word" configuration

### Changing the Wake Word

1. Open the digital human page settings
2. Switch to the "Wake Word" tab
3. Change the enabled state or the wake word list
4. Click "Apply Wake Word"
5. Follow the prompt to decide whether to restart immediately

### Disabling the Wake Word

1. Change "Enable local wake word" to disabled
2. Click "Apply Wake Word"
3. Restarting once immediately is recommended

After disabling:

- The page and the event bridge remain available
- Wake word detection no longer runs
