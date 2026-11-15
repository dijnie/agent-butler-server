# How to Get Device Information with an MCP Method

This tutorial shows you how to get device information with an MCP method.

Step 1: Customize your `agent-base-prompt.txt` file

Copy the contents of the `agent-base-prompt.txt` file in the xiaozhi-server directory to your `data` directory, and rename it `.agent-base-prompt.txt`.

Step 2: Edit the `data/.agent-base-prompt.txt` file, find the `<context>` tag, and add the following code inside the tag content:
```
- **Device ID:** {{device_id}}
```

After adding it, the content of the `<context>` tag in your `data/.agent-base-prompt.txt` file looks roughly like this:
```
<context>
[Important: The following info is provided in real time, no tool calls are needed, use it directly:]
- **Device ID:** {{device_id}}
- **Current time:** {{current_time}}
- **Today's date:** {{today_date}} ({{today_weekday}})
- **Today's lunar date:** {{lunar_date}}
- **User's city:** {{local_address}}
- **Local weather for the next 7 days:** {{weather_info}}
</context>
```

Step 3: Edit the `data/.config.yaml` file, find the `agent-base-prompt` setting. Before the change, it looks like this:
```
prompt_template: agent-base-prompt.txt
```
Change it to
```
prompt_template: data/.agent-base-prompt.txt
```

Step 4: Restart your xiaozhi-server service.

Step 5: In your MCP method, add a parameter named `device_id` of type `string` with the description `Device ID`.

Step 6: Wake Xiaozhi again and have it call your MCP method, then check whether your MCP method can get the `Device ID`.
