# Control Console: Volcano Engine Dual-Stream Speech Synthesis + Voice Cloning Configuration Tutorial

This tutorial has 4 stages: preparation, configuration, cloning, and usage. It mainly describes how to configure Volcano Engine dual-stream speech synthesis + voice cloning through the control console.

## Stage 1: Preparation
The super administrator first activates the Volcano Engine service and obtains the App Id and Access Token. By default Volcano Engine gives you one voice resource for free. This voice resource must be copied into this project.

If you want to clone multiple voices, you need to purchase and activate multiple voice resources. Just copy the voice ID (S_xxxxx) of each voice resource into this project, and then assign it to a system account. The detailed steps are as follows:

### 1. Activate the Volcano Engine service
Visit https://console.volcengine.com/speech/app , create an application under application management, and check the speech synthesis large model and the voice cloning large model.

### 2. Get the voice resource ID
Visit https://console.volcengine.com/speech/service/9999 and copy three items: the App Id, the Access Token, and the voice ID (S_xxxxx). As shown in the figure

![Get the voice resource](images/image-clone-integration-01.png)

## Stage 2: Configure the Volcano Engine service

### 1. Fill in the Volcano Engine configuration

Log in to the control console with the super administrator account, click [Models] at the top, then click [Text-to-Speech] on the left of the model configuration page, search for and find "火山双流式语音合成" (Volcano Engine dual-stream speech synthesis), and click Edit. Enter your Volcano Engine `App Id` in the [应用ID] (Application ID) field and the `Access Token` in the [访问令牌] (Access Token) field. Then save.

### 2. Assign the voice resource ID to a system account

Log in to the control console with the super administrator account, click `More` at the top, and in the drop-down menu click the `System Feature Management` page. On the page check `Voice Clone` and click Save Configuration. You will then see the `Voice Clone` button in the top menu.

Log in to the control console with the super administrator account, and click [Voice Clone] and [Voice Resource] at the top.

Click the Add button, and for [Platform Name] choose "火山双流式语音合成" (Volcano Engine dual-stream speech synthesis);

In [音色资源ID] (Voice Resource ID), enter your Volcano Engine voice resource ID (S_xxxxx), and press Enter after entering it;

In [Account Owner], choose the system account you want to assign it to; you can assign it to yourself. Then click Save

## Stage 3: Cloning

If, after logging in, you click [Voice Clone] > [Voice Clone] at the top and it shows [Your account has no voice resources assigned, please contact the administrator to assign voice resources], you have not assigned the voice resource ID to this account in Stage 2. Go back to Stage 2 and assign the voice resource to the account.

If, after logging in, you click [Voice Clone] > [Voice Clone] at the top and can see the corresponding voice list, continue.

In the list you will see the corresponding voices. Choose one of the voice resources and click the [Upload Audio] button. After uploading, you can listen to the sound or trim a section of it. After confirming, click the [Upload Audio] button.
![Upload audio](images/image-clone-integration-02.png)

After uploading the audio, the corresponding voice in the list changes to the "Waiting for clone" state. Click the [Clone Voice] button. Wait 1 to 2 seconds for the result.

If cloning fails, hover the mouse over the "error message" icon and the reason for the failure is shown.

If cloning succeeds, the corresponding voice in the list changes to the "Training successful" state. You can then click the edit button in the [Voice Name] column and change the name of the voice resource to make it easier to choose later.

## Stage 4: Usage

Click [Agents] at the top, choose any agent, and click the [Config Role] button.

For Text-to-Speech (TTS) choose "火山双流式语音合成" (Volcano Engine dual-stream speech synthesis). In the list, find the voice resource whose name contains "克隆音色" (cloned voice) (see the figure), select it, and click Save.
![Select the voice](images/image-clone-integration-03.png)

Next, you can wake Xiaozhi and talk to it.
