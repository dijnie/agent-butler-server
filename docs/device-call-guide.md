# Device-to-Device Call Plugin Guide

## Overview

The device call feature lets two configured devices communicate in both directions over a voice/data channel. When device A calls device B, the system works through the following flow:

```
Device A → Permission check → MQTT gateway → Remote wake-up of device B → Connection established → Call established
```
## Prerequisites for this feature
1. You must have at least two devices, and each must be an `ESP32-S3`, because only the `ESP32-S3` supports the remote wake-up feature.
2. Your device must have `two microphones`. If your device has only `a single microphone` and you just want to try the feature, that also works, but it will stutter noticeably.
3. You must use the [full-module deployment](Deployment_all.md) of this project, because you need the `control console` to manage device permissions and communication.
4. You must install and configure an [MQTT gateway service](mqtt-gateway-integration.md) from `May 27, 2026` or later. If you have already deployed the MQTT gateway service, confirm that the code version is from after `May 27, 2026`.

These are the hard requirements for this feature. The details follow.

## Configuration steps

### Step 1: Enable the Address Book feature

1. Confirm your control console version is `0.9.4` or later.
2. Log in to the control console backend
3. Go to **System Feature Management**
4. In the feature list on the left, check **Address Book**
5. Click **Save Configuration** to confirm

### Step 2: Configure device-to-device call permissions

1. In the top menu of the control console, click **Address Book**
2. Under the agent on the left, select your device A in the device list (you can search by MAC address or remark)
3. In the details panel on the right, find the name setting for the target device B, for example **"Xiao Wang"**
4. Check the **Device Call Permission** checkbox for device B
5. Click **Save Permissions**

**Two-way authorization:** For device A and device B to communicate with each other, each side must be granted permission for the other in the control console. For example:

- Check device B in device A's configuration → device A can communicate with device B
- Check device A in device B's configuration → device B can communicate with device A

### Step 3: Add the call tool in the agent configuration

1. In the top menu of the control console, click **Agents**
2. On the agent for which you just configured the device contacts, click **Config Role**
3. In the details panel on the right, click **Edit Functions**
4. Check the **Device-to-device call** tool
5. Click **Save Configuration** to confirm
6. Click **Save Configuration** again on the outer page, then restart the device

### Step 4: Add the remote wake-up tool to the firmware

1. On top of the [xiaozhi-esp32](https://github.com/78/xiaozhi-esp32) code, add the remote wake-up MCP tool. Supported versions are 2.1.0 to 2.2.6 (the version of May 29, 2026)
2. Add the remote wake-up function declaration in application.h
    ```cpp
    void RemoteWakeup(const std::string& reason);
    ```
3. Add the remote wake-up function in application.cc
    ```cpp
    void Application::RemoteWakeup(const std::string& reason){
        if (!protocol_) {
            return;
        }

        auto state = GetDeviceState();
        
        if (state == kDeviceStateIdle) {
            audio_service_.EncodeWakeWord();

            if (!protocol_->IsAudioChannelOpened()) {
                SetDeviceState(kDeviceStateConnecting);
                if (!protocol_->OpenAudioChannel()) {
                    audio_service_.EnableWakeWordDetection(true);
                    return;
                }
            }
            std::string wake_word = reason;
    #if CONFIG_USE_AFE_WAKE_WORD || CONFIG_USE_CUSTOM_WAKE_WORD
            // Encode and send the wake word data to the server
            while (auto packet = audio_service_.PopWakeWordPacket()) {
                protocol_->SendAudio(std::move(packet));
            }
            // Set the chat state to wake word detected
            protocol_->SendWakeWordDetected(wake_word);
            SetListeningMode(aec_mode_ == kAecOff ? kListeningModeAutoStop : kListeningModeRealtime);
    #else
            // Set flag to play popup sound after state changes to listening
            // (PlaySound here would be cleared by ResetDecoder in EnableVoiceProcessing)
            play_popup_on_listening_ = true;
            SetListeningMode(aec_mode_ == kAecOff ? kListeningModeAutoStop : kListeningModeRealtime);
    #endif
        } else if (state == kDeviceStateSpeaking) {
            AbortSpeaking(kAbortReasonWakeWordDetected);
            SetDeviceState(kDeviceStateIdle);
        } else if (state == kDeviceStateActivating) {
            SetDeviceState(kDeviceStateIdle);
        }
    }
    ```
4. Add the remote wake-up tool in mcp_server.cc
    ```cpp
    AddUserOnlyTool("self.remote_wakeup", "Remote wakeup function with configurable parameters",
        PropertyList({
            Property("reason", kPropertyTypeString, "Wakeup reason"),
        }),
        [this](const PropertyList& properties) -> ReturnValue {
            std::string reason = properties["reason"].value<std::string>();
            ESP_LOGI(TAG, "Wakeup reason=%s", reason.c_str());
            auto& app = Application::GetInstance();
            app.RemoteWakeup(reason);
            return true;
    ```
5. Flash the firmware by following the [firmware build and flash guide](firmware-build.md)
6. Whether your device has one or two microphones, check the option to enable AEC during the build!
7. Whether your device has one or two microphones, check the option to enable AEC during the build!
8. Whether your device has one or two microphones, check the option to enable AEC during the build!

### Step 5: Configure the MQTT gateway service

1. Deploy the MQTT gateway service, see the [MQTT gateway integration guide](mqtt-gateway-integration.md)
2. If it is already deployed, confirm the code version is from May 27, 2026

## Call flow

Prepare two devices. After configuring the communication permissions in the control console and adding the call tool to the agent, say to one of the Xiaozhi devices: "Call XXX", and watch whether device B responds.

## FAQ

### Q: Device B does not respond to the call?

- Check whether device B is online (device status in the control console)
- Confirm that device B's firmware has the remote wake-up tool integrated correctly
- Check that the MQTT gateway connection is normal
- Verify that the two-way permission configuration is complete

### Q: The prompt says "no call permission"?

- In the control console, confirm that device A has device B's call permission checked
- Confirm the configuration has been saved (not just modified)

### Q: How do I confirm the Address Book feature is enabled?

- If the top menu of the control console shows an "Address Book" entry, it is enabled

### Q: I tell it to call "张山" (Zhang Shan), but it keeps recognizing "张三" (Zhang San). What can I do?
- Check the documentation of the ASR service you use to see whether it supports hot word recognition.
- If you use `FunASRServer`, you can add "张山" to the `hot word file` inside the container, then restart the container.
- If you use the `Volcano Engine` service, you can add a `hot word file` in the `Volcano Engine console`, then go back to the `Models` page of the control console, find the entry named `豆包语音识别(流式)` (Doubao speech recognition, streaming) under `Speech Recognition`, click `Edit`, and note that the `Supplier` in the dialog is `火山引擎语音识别(流式)` (Volcano Engine speech recognition, streaming). In the `Call Information` area of the dialog, enter the `hot word file name` in the corresponding input box, and click `Save`.
- The entries `豆包语音识别2.0(流式)` (Doubao speech recognition 2.0, streaming; supplier `火山引擎语音识别(流式)`) and `豆包语音识别` (Doubao speech recognition; supplier `火山引擎语音识别`) also have the `hot word file name` field and work the same way. Be careful not to pick the wrong row.
- After changing it, the device must reconnect for it to take effect: the latest private configuration is only pulled when a device connects, and a device that stays connected does not change automatically.

