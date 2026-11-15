This is a developer document. To deploy the Xiaozhi server, [click here for the deployment tutorial](../../README.md#deployment-documentation)

For all-in-one digital human deployment, Kiosk full-screen startup and system environment configuration, [click here for the all-in-one deployment guide](../../docs/all-in-one-digital-human-setup.md)

For wake word model download, runtime configuration and detailed usage, [click here for the wake word documentation](../../docs/digital-human-wakeword.md)

# Project Introduction

digital-human is a standalone digital human test module. It provides a local test page, front-end interaction resources, a wake word runtime and an event bridge, used to debug the whole digital human interaction pipeline end to end.

# Quick Start

Install dependencies:

```bash
pip install -r wakeword_runtime/requirements.txt
```

Start the module:

```bash
python start.py
```

# Access URLs

After startup you can access:

- Page URL: http://127.0.0.1:8006/index.html
- Event bridge URL: ws://127.0.0.1:8006/wakeword-ws
- Health check: http://127.0.0.1:8006/health

# Directory Layout

- `start.py`: module startup entry
- `index.html`: digital human test page entry
- `wakeword_runtime`: local wake word runtime and configuration directory
- `js`, `css`: page front-end scripts and styles
- `images`, `resources`: page resource files

# Related Documents

- All-in-one deployment guide: for full-device deployment on x86 devices, Kiosk display and auto-start on boot configuration
	[../../docs/all-in-one-digital-human-setup.md](../../docs/all-in-one-digital-human-setup.md)
- Wake word documentation: for wake word model download, runtime configuration and local debugging
	[../../docs/digital-human-wakeword.md](../../docs/digital-human-wakeword.md)
