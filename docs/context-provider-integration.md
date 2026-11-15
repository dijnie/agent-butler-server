# Context Provider Tutorial

## Overview

A `context provider` adds a [data source] to the context of Xiaozhi's system prompt.

At the moment Xiaozhi wakes up, a `context provider` fetches data from external systems and dynamically injects it into the large model's system prompt.
This lets Xiaozhi perceive the state of something in the world at wake-up.

It is fundamentally different from MCP and memory: a `context provider` forces Xiaozhi to perceive data from the world; `memory (Mem)` lets it know what was discussed before; `MCP (function_call)` is invoked when a certain capability or piece of knowledge is needed.

With this feature, at the instant Xiaozhi wakes up, it "perceives":
- Health sensor status (body temperature, blood pressure, blood oxygen, etc.)
- Real-time data of business systems (server load, to-do items, stock information, etc.)
- Any text information that can be obtained through an HTTP API

**Note**: This feature only lets Xiaozhi perceive the state of things at wake-up. If you want Xiaozhi to obtain the state of things in real time after waking up, combine this feature with MCP tool calls.

## How It Works

1. **Configure sources**: the user configures one or more HTTP API URLs.
2. **Trigger requests**: when the system builds the prompt, if it finds the `{{ dynamic_context }}` placeholder in the template, it requests all configured APIs.
3. **Automatic injection**: the system formats the data returned by the APIs as a Markdown list and replaces the `{{ dynamic_context }}` placeholder.

## API Specification

For Xiaozhi to parse the data correctly, your API must meet the following specification:

- **Request method**: `GET`
- **Request headers**: the system automatically adds a `device-id` field to the request header.
- **Response format**: must return JSON that contains the `code` and `data` fields.

### Response Examples

**Case 1: returning key-value pairs**
```json
{
  "code": 0,
  "msg": "success",
  "data": {
    "Living room temperature": "26℃",
    "Living room humidity": "45%",
    "Front door status": "Closed"
  }
}
```
*Injection result:*
```markdown
<context>
- **Living room temperature:** 26℃
- **Living room humidity:** 45%
- **Front door status:** Closed
</context>
```

**Case 2: returning a list**
```json
{
  "code": 0,
  "data": [
    "You have 10 to-do items",
    "The car is currently traveling at 100 km/h"
  ]
}
```
*Injection result:*
```markdown
<context>
- You have 10 to-do items
- The car is currently traveling at 100 km/h
</context>
```

## Configuration Guide

### Option 1: Configure in the control console (full-module deployment)

1. Log in to the control console and go to the **Config Role** page.
2. Find the **Context** setting (click the "Edit Source" button).
3. Click **Add** and enter your API URL.
4. If the API requires authentication, add `Authorization` or other headers in the **Request Headers** section.
5. Save the configuration.

### Option 2: Configure in the config file (single-module deployment)

Edit the `xiaozhi-server/data/.config.yaml` file and add a `context_providers` section:

```yaml
# Context provider configuration
context_providers:
  - url: "http://api.example.com/data"
    headers:
      Authorization: "Bearer your-token"
  - url: "http://another-api.com/data"
```

## Enabling the Feature

By default, the system's prompt template file (`data/.agent-base-prompt.txt`) already contains the `{{ dynamic_context }}` placeholder, so you do not need to add it manually.

**Example:**

```markdown
<context>
[Important! The following information is provided in real time. No tool call is needed to look it up; use it directly:]
- **Device ID:** {{device_id}}
- **Current time:** {{current_time}}
...
{{ dynamic_context }}
</context>
```

**Note**: If you do not need this feature, you can **leave all context providers unconfigured**, or **delete** the `{{ dynamic_context }}` placeholder from the prompt template file.

## Appendix: Mock Test Service Example

To make testing and development easier, here is a simple Python mock server script. You can run it to simulate the API locally.

**mock_api_server.py**

```python
import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs

# Set the port number
PORT = 8081

class MockRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Parse the path and parameters
        parsed_path = urlparse(self.path)
        path = parsed_path.path
        query = parse_qs(parsed_path.query)

        response_data = {}
        status_code = 200

        print(f"Request received: {path}, parameters: {query}")

        # Case 1: simulate health data (returns a dict)
        # Path style: /health
        # device_id is read from the header
        if path == "/health":
            device_id = self.headers.get("device-id", "unknown_device")
            print(f"device_id: {device_id}")
            response_data = {
                "code": 0,
                "msg": "success",
                "data": {
                    "Test device ID": device_id,
                    "Heart rate": "80 bpm",
                    "Blood pressure": "120/80 mmHg",
                    "Status": "Good"
                }
            }

        # Case 2: simulate a news list (returns a list)
        # No parameters: /news/list
        elif path == "/news/list":
            response_data = {
                "code": 0,
                "msg": "success",
                "data": [
                    "Top story: Python 3.14 released",
                    "Tech news: AI assistants are changing life",
                    "Local news: heavy rain tomorrow, remember your umbrella"
                ]
            }

        # Case 3: simulate a weather brief (returns a string)
        # No parameters: /weather/simple
        elif path == "/weather/simple":
            response_data = {
                "code": 0,
                "msg": "success",
                "data": "Sunny turning cloudy today, 20-25 degrees, excellent air quality, good for going out."
            }

        # Case 4: simulate device details (query parameter style)
        # Parameter style: /device/info
        # device_id is read from the header
        elif path == "/device/info":
            device_id = self.headers.get("device-id", "unknown_device")
            response_data = {
                "code": 0,
                "msg": "success",
                "data": {
                    "Query method": "Header parameter",
                    "Device ID": device_id,
                    "Battery": "85%",
                    "Firmware": "v2.0.1"
                }
            }
        
        # Case 5: 404 Not Found
        else:
            status_code = 404
            response_data = {"error": "Endpoint does not exist"}

        # Send the response
        self.send_response(status_code)
        self.send_header('Content-type', 'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(json.dumps(response_data, ensure_ascii=False).encode('utf-8'))

# Start the service
# Allow address reuse to avoid errors on quick restarts
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", PORT), MockRequestHandler) as httpd:
    print(f"==================================================")
    print(f"Mock API Server started: http://localhost:{PORT}")
    print(f"Available endpoints:")
    print(f"1. [Dict] http://localhost:{PORT}/health")
    print(f"2. [List] http://localhost:{PORT}/news/list")
    print(f"3. [Text] http://localhost:{PORT}/weather/simple")
    print(f"4. [Params] http://localhost:{PORT}/device/info")
    print(f"==================================================")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nService stopped")
```
