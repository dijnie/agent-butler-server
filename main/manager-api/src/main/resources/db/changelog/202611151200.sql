-- Translate the Chinese display text of seeded rows into English.
-- Only human-readable columns are updated (names, labels, remarks, prompts);
-- codes, values, ids, config_json and sort orders are left untouched.
-- Every statement is keyed by primary key, so it is a no-op when the row does not exist.

-- sys_params: parameter remarks
UPDATE `sys_params` SET `remark` = 'Server secret key' WHERE `id` = 102;
UPDATE `sys_params` SET `remark` = 'Whether to allow users other than the administrator to register' WHERE `id` = 103;
UPDATE `sys_params` SET `remark` = 'Control panel address shown when the six-digit verification code is issued' WHERE `id` = 104;
UPDATE `sys_params` SET `remark` = 'Maximum number of characters a single device may output per day; 0 means unlimited' WHERE `id` = 105;
UPDATE `sys_params` SET `remark` = 'WebSocket addresses; separate multiple addresses with ;' WHERE `id` = 106;
UPDATE `sys_params` SET `remark` = 'OTA address' WHERE `id` = 107;
UPDATE `sys_params` SET `remark` = 'System name' WHERE `id` = 108;
UPDATE `sys_params` SET `remark` = 'ICP filing number; set to null to leave it unset' WHERE `id` = 109;
UPDATE `sys_params` SET `remark` = 'Public security filing number; set to null to leave it unset' WHERE `id` = 110;
UPDATE `sys_params` SET `remark` = 'Whether to enable registration by mobile number' WHERE `id` = 111;
UPDATE `sys_params` SET `remark` = 'Maximum number of SMS messages sent to a single number per day' WHERE `id` = 112;
UPDATE `sys_params` SET `remark` = 'MCP endpoint address' WHERE `id` = 113;
UPDATE `sys_params` SET `remark` = 'Voiceprint API address' WHERE `id` = 114;
UPDATE `sys_params` SET `remark` = 'Voiceprint recognition similarity threshold, range 0.0-1.0, default 0.4; the higher the value, the stricter' WHERE `id` = 115;
UPDATE `sys_params` SET `remark` = 'MQTT gateway configuration' WHERE `id` = 116;
UPDATE `sys_params` SET `remark` = 'MQTT signature key configuration' WHERE `id` = 117;
UPDATE `sys_params` SET `remark` = 'UDP gateway configuration' WHERE `id` = 118;
UPDATE `sys_params` SET `remark` = 'Address of the MQTT gateway management API' WHERE `id` = 119;
UPDATE `sys_params` SET `remark` = 'Server SM2 public key' WHERE `id` = 120;
UPDATE `sys_params` SET `remark` = 'Server SM2 private key' WHERE `id` = 121;
UPDATE `sys_params` SET `remark` = 'Whether token authentication is enabled for the server module' WHERE `id` = 122;
UPDATE `sys_params` SET `remark` = 'Console log format' WHERE `id` = 201;
UPDATE `sys_params` SET `remark` = 'File log format' WHERE `id` = 202;
UPDATE `sys_params` SET `remark` = 'Log level' WHERE `id` = 203;
UPDATE `sys_params` SET `remark` = 'Log directory' WHERE `id` = 204;
UPDATE `sys_params` SET `remark` = 'Log file name' WHERE `id` = 205;
UPDATE `sys_params` SET `remark` = 'Data directory' WHERE `id` = 206;
UPDATE `sys_params` SET `remark` = 'Whether to delete audio files after use' WHERE `id` = 301;
UPDATE `sys_params` SET `remark` = 'Time before disconnecting when there is no voice input (seconds)' WHERE `id` = 302;
UPDATE `sys_params` SET `remark` = 'TTS request timeout (seconds)' WHERE `id` = 303;
UPDATE `sys_params` SET `remark` = 'Whether to enable wake word acceleration' WHERE `id` = 304;
UPDATE `sys_params` SET `remark` = 'Whether to enable the opening greeting' WHERE `id` = 305;
UPDATE `sys_params` SET `remark` = 'Whether to enable the end notification sound' WHERE `id` = 306;
UPDATE `sys_params` SET `remark` = 'File path of the end notification sound' WHERE `id` = 307;
UPDATE `sys_params` SET `remark` = 'Exit command list' WHERE `id` = 308;
UPDATE `sys_params` SET `remark` = 'Xiaozhi type' WHERE `id` = 309;
UPDATE `sys_params` SET `remark` = 'Wake word list, used to recognize wake words' WHERE `id` = 310;
UPDATE `sys_params` SET `remark` = 'Whether to enable the WebSocket heartbeat keep-alive mechanism' WHERE `id` = 311;
UPDATE `sys_params` SET `remark` = 'Tool call timeout (seconds)' WHERE `id` = 312;
UPDATE `sys_params` SET `remark` = 'Whether to enable the closing remark' WHERE `id` = 500;
UPDATE `sys_params` SET `remark` = 'Closing remark prompt' WHERE `id` = 501;
UPDATE `sys_params` SET `remark` = 'Reply when a system error occurs' WHERE `id` = 502;
UPDATE `sys_params` SET `remark` = 'System feature menu configuration' WHERE `id` = 600;
UPDATE `sys_params` SET `remark` = 'Alibaba Cloud platform access_key' WHERE `id` = 610;
UPDATE `sys_params` SET `remark` = 'Alibaba Cloud platform access_key_secret' WHERE `id` = 611;
UPDATE `sys_params` SET `remark` = 'Alibaba Cloud SMS signature' WHERE `id` = 612;
UPDATE `sys_params` SET `remark` = 'Alibaba Cloud SMS template' WHERE `id` = 613;

-- sys_dict_type: dictionary names and remarks
UPDATE `sys_dict_type` SET `dict_name` = 'Firmware type', `remark` = 'Firmware type dictionary' WHERE `id` = 101;
UPDATE `sys_dict_type` SET `dict_name` = 'Mobile area', `remark` = 'Mobile area dictionary' WHERE `id` = 102;

-- sys_dict_data: dictionary labels and remarks (firmware types, mobile areas)
UPDATE `sys_dict_data` SET `dict_label` = 'Breadboard, new wiring (WiFi)', `remark` = 'Breadboard, new wiring (WiFi)' WHERE `id` = 101001;
UPDATE `sys_dict_data` SET `dict_label` = 'Breadboard, new wiring (WiFi) + LCD', `remark` = 'Breadboard, new wiring (WiFi) + LCD' WHERE `id` = 101002;
UPDATE `sys_dict_data` SET `dict_label` = 'Breadboard, new wiring (ML307 AT)', `remark` = 'Breadboard, new wiring (ML307 AT)' WHERE `id` = 101003;
UPDATE `sys_dict_data` SET `dict_label` = 'Breadboard (WiFi) ESP32 DevKit', `remark` = 'Breadboard (WiFi) ESP32 DevKit' WHERE `id` = 101004;
UPDATE `sys_dict_data` SET `dict_label` = 'Breadboard (WiFi + LCD) ESP32 DevKit', `remark` = 'Breadboard (WiFi + LCD) ESP32 DevKit' WHERE `id` = 101005;
UPDATE `sys_dict_data` SET `dict_label` = 'DFRobot UNIHIKER K10', `remark` = 'DFRobot UNIHIKER K10' WHERE `id` = 101006;
UPDATE `sys_dict_data` SET `dict_label` = 'Kevin SP V3 dev board', `remark` = 'Kevin SP V3 dev board' WHERE `id` = 101014;
UPDATE `sys_dict_data` SET `dict_label` = 'Kevin SP V4 dev board', `remark` = 'Kevin SP V4 dev board' WHERE `id` = 101015;
UPDATE `sys_dict_data` SET `dict_label` = 'Yuying Tech 3.13 LCD dev board', `remark` = 'Yuying Tech 3.13 LCD dev board' WHERE `id` = 101016;
UPDATE `sys_dict_data` SET `dict_label` = 'LCSC Shizhanpai ESP32-S3 dev board', `remark` = 'LCSC Shizhanpai ESP32-S3 dev board' WHERE `id` = 101017;
UPDATE `sys_dict_data` SET `dict_label` = 'LCSC Shizhanpai ESP32-C3 dev board', `remark` = 'LCSC Shizhanpai ESP32-C3 dev board' WHERE `id` = 101018;
UPDATE `sys_dict_data` SET `dict_label` = 'Magic Button Magiclick_2.4', `remark` = 'Magic Button Magiclick_2.4' WHERE `id` = 101019;
UPDATE `sys_dict_data` SET `dict_label` = 'Magic Button Magiclick_2.5', `remark` = 'Magic Button Magiclick_2.5' WHERE `id` = 101020;
UPDATE `sys_dict_data` SET `dict_label` = 'Magic Button Magiclick_C3', `remark` = 'Magic Button Magiclick_C3' WHERE `id` = 101021;
UPDATE `sys_dict_data` SET `dict_label` = 'Magic Button Magiclick_C3_v2', `remark` = 'Magic Button Magiclick_C3_v2' WHERE `id` = 101022;
UPDATE `sys_dict_data` SET `dict_label` = 'Xiage Mini C3', `remark` = 'Xiage Mini C3' WHERE `id` = 101028;
UPDATE `sys_dict_data` SET `dict_label` = 'ESP32S3_KORVO2_V3 dev board', `remark` = 'ESP32S3_KORVO2_V3 dev board' WHERE `id` = 101029;
UPDATE `sys_dict_data` SET `dict_label` = 'ESP-SparkBot dev board', `remark` = 'ESP-SparkBot dev board' WHERE `id` = 101030;
UPDATE `sys_dict_data` SET `dict_label` = 'Tudouzi', `remark` = 'Tudouzi' WHERE `id` = 101037;
UPDATE `sys_dict_data` SET `dict_label` = 'Movecall Moji (Xiaozhi AI derivative)', `remark` = 'Movecall Moji (Xiaozhi AI derivative)' WHERE `id` = 101040;
UPDATE `sys_dict_data` SET `dict_label` = 'Movecall CuiCan AI pendant', `remark` = 'Movecall CuiCan AI pendant' WHERE `id` = 101041;
UPDATE `sys_dict_data` SET `dict_label` = 'ALIENTEK DNESP32S3 dev board', `remark` = 'ALIENTEK DNESP32S3 dev board' WHERE `id` = 101042;
UPDATE `sys_dict_data` SET `dict_label` = 'ALIENTEK DNESP32S3-BOX', `remark` = 'ALIENTEK DNESP32S3-BOX' WHERE `id` = 101043;
UPDATE `sys_dict_data` SET `dict_label` = 'Dudu dev board CHATX (WiFi)', `remark` = 'Dudu dev board CHATX (WiFi)' WHERE `id` = 101044;
UPDATE `sys_dict_data` SET `dict_label` = 'Taiji Pi ESP32-S3', `remark` = 'Taiji Pi ESP32-S3' WHERE `id` = 101045;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 0.85 (WIFI)', `remark` = 'Nologo Tech Xingzhi 0.85 (WIFI)' WHERE `id` = 101046;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 0.85 (ML307)', `remark` = 'Nologo Tech Xingzhi 0.85 (ML307)' WHERE `id` = 101047;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 0.96 (WIFI)', `remark` = 'Nologo Tech Xingzhi 0.96 (WIFI)' WHERE `id` = 101048;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 0.96 (ML307)', `remark` = 'Nologo Tech Xingzhi 0.96 (ML307)' WHERE `id` = 101049;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 1.54 (WIFI)', `remark` = 'Nologo Tech Xingzhi 1.54 (WIFI)' WHERE `id` = 101050;
UPDATE `sys_dict_data` SET `dict_label` = 'Nologo Tech Xingzhi 1.54 (ML307)', `remark` = 'Nologo Tech Xingzhi 1.54 (ML307)' WHERE `id` = 101051;
UPDATE `sys_dict_data` SET `dict_label` = 'DOIT AI companion box', `remark` = 'DOIT AI companion box' WHERE `id` = 101053;
UPDATE `sys_dict_data` SET `dict_label` = 'Yuankong Qingchun', `remark` = 'Yuankong Qingchun' WHERE `id` = 101054;
UPDATE `sys_dict_data` SET `dict_label` = 'Chinese Mainland', `remark` = 'Chinese Mainland' WHERE `id` = 102001;
UPDATE `sys_dict_data` SET `dict_label` = 'Hong Kong, China', `remark` = 'Hong Kong, China' WHERE `id` = 102002;
UPDATE `sys_dict_data` SET `dict_label` = 'Macao, China', `remark` = 'Macao, China' WHERE `id` = 102003;
UPDATE `sys_dict_data` SET `dict_label` = 'Taiwan, China', `remark` = 'Taiwan, China' WHERE `id` = 102004;
UPDATE `sys_dict_data` SET `dict_label` = 'USA/Canada', `remark` = 'USA/Canada' WHERE `id` = 102005;
UPDATE `sys_dict_data` SET `dict_label` = 'United Kingdom', `remark` = 'United Kingdom' WHERE `id` = 102006;
UPDATE `sys_dict_data` SET `dict_label` = 'France', `remark` = 'France' WHERE `id` = 102007;
UPDATE `sys_dict_data` SET `dict_label` = 'Italy', `remark` = 'Italy' WHERE `id` = 102008;
UPDATE `sys_dict_data` SET `dict_label` = 'Germany', `remark` = 'Germany' WHERE `id` = 102009;
UPDATE `sys_dict_data` SET `dict_label` = 'Poland', `remark` = 'Poland' WHERE `id` = 102010;
UPDATE `sys_dict_data` SET `dict_label` = 'Switzerland', `remark` = 'Switzerland' WHERE `id` = 102011;
UPDATE `sys_dict_data` SET `dict_label` = 'Spain', `remark` = 'Spain' WHERE `id` = 102012;
UPDATE `sys_dict_data` SET `dict_label` = 'Denmark', `remark` = 'Denmark' WHERE `id` = 102013;
UPDATE `sys_dict_data` SET `dict_label` = 'Malaysia', `remark` = 'Malaysia' WHERE `id` = 102014;
UPDATE `sys_dict_data` SET `dict_label` = 'Australia', `remark` = 'Australia' WHERE `id` = 102015;
UPDATE `sys_dict_data` SET `dict_label` = 'Indonesia', `remark` = 'Indonesia' WHERE `id` = 102016;
UPDATE `sys_dict_data` SET `dict_label` = 'Philippines', `remark` = 'Philippines' WHERE `id` = 102017;
UPDATE `sys_dict_data` SET `dict_label` = 'New Zealand', `remark` = 'New Zealand' WHERE `id` = 102018;
UPDATE `sys_dict_data` SET `dict_label` = 'Singapore', `remark` = 'Singapore' WHERE `id` = 102019;
UPDATE `sys_dict_data` SET `dict_label` = 'Thailand', `remark` = 'Thailand' WHERE `id` = 102020;
UPDATE `sys_dict_data` SET `dict_label` = 'Japan', `remark` = 'Japan' WHERE `id` = 102021;
UPDATE `sys_dict_data` SET `dict_label` = 'South Korea', `remark` = 'South Korea' WHERE `id` = 102022;
UPDATE `sys_dict_data` SET `dict_label` = 'Vietnam', `remark` = 'Vietnam' WHERE `id` = 102023;
UPDATE `sys_dict_data` SET `dict_label` = 'India', `remark` = 'India' WHERE `id` = 102024;
UPDATE `sys_dict_data` SET `dict_label` = 'Pakistan', `remark` = 'Pakistan' WHERE `id` = 102025;
UPDATE `sys_dict_data` SET `dict_label` = 'Nigeria', `remark` = 'Nigeria' WHERE `id` = 102026;
UPDATE `sys_dict_data` SET `dict_label` = 'Bangladesh', `remark` = 'Bangladesh' WHERE `id` = 102027;
UPDATE `sys_dict_data` SET `dict_label` = 'Saudi Arabia', `remark` = 'Saudi Arabia' WHERE `id` = 102028;
UPDATE `sys_dict_data` SET `dict_label` = 'United Arab Emirates', `remark` = 'United Arab Emirates' WHERE `id` = 102029;
UPDATE `sys_dict_data` SET `dict_label` = 'Brazil', `remark` = 'Brazil' WHERE `id` = 102030;
UPDATE `sys_dict_data` SET `dict_label` = 'Mexico', `remark` = 'Mexico' WHERE `id` = 102031;
UPDATE `sys_dict_data` SET `dict_label` = 'Chile', `remark` = 'Chile' WHERE `id` = 102032;
UPDATE `sys_dict_data` SET `dict_label` = 'Argentina', `remark` = 'Argentina' WHERE `id` = 102033;
UPDATE `sys_dict_data` SET `dict_label` = 'Egypt', `remark` = 'Egypt' WHERE `id` = 102034;
UPDATE `sys_dict_data` SET `dict_label` = 'South Africa', `remark` = 'South Africa' WHERE `id` = 102035;
UPDATE `sys_dict_data` SET `dict_label` = 'Kenya', `remark` = 'Kenya' WHERE `id` = 102036;
UPDATE `sys_dict_data` SET `dict_label` = 'Tanzania', `remark` = 'Tanzania' WHERE `id` = 102037;
UPDATE `sys_dict_data` SET `dict_label` = 'Kazakhstan', `remark` = 'Kazakhstan' WHERE `id` = 102038;

-- ai_model_provider: provider display names
UPDATE `ai_model_provider` SET `name` = 'SileroVAD voice activity detection' WHERE `id` = 'SYSTEM_VAD_SileroVAD';
UPDATE `ai_model_provider` SET `name` = 'FunASR speech recognition' WHERE `id` = 'SYSTEM_ASR_FunASR';
UPDATE `ai_model_provider` SET `name` = 'SherpaASR speech recognition' WHERE `id` = 'SYSTEM_ASR_SherpaASR';
UPDATE `ai_model_provider` SET `name` = 'Volcano Engine speech recognition' WHERE `id` = 'SYSTEM_ASR_DoubaoASR';
UPDATE `ai_model_provider` SET `name` = 'OpenAI API' WHERE `id` = 'SYSTEM_LLM_openai';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Bailian API' WHERE `id` = 'SYSTEM_LLM_AliBL';
UPDATE `ai_model_provider` SET `name` = 'Ollama API' WHERE `id` = 'SYSTEM_LLM_ollama';
UPDATE `ai_model_provider` SET `name` = 'Dify API' WHERE `id` = 'SYSTEM_LLM_dify';
UPDATE `ai_model_provider` SET `name` = 'Gemini API' WHERE `id` = 'SYSTEM_LLM_gemini';
UPDATE `ai_model_provider` SET `name` = 'Coze API' WHERE `id` = 'SYSTEM_LLM_coze';
UPDATE `ai_model_provider` SET `name` = 'FastGPT API' WHERE `id` = 'SYSTEM_LLM_fastgpt';
UPDATE `ai_model_provider` SET `name` = 'Xinference API' WHERE `id` = 'SYSTEM_LLM_xinference';
UPDATE `ai_model_provider` SET `name` = 'Volcano Engine TTS' WHERE `id` = 'SYSTEM_TTS_doubao';
UPDATE `ai_model_provider` SET `name` = 'SiliconFlow TTS' WHERE `id` = 'SYSTEM_TTS_siliconflow';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Cloud TTS' WHERE `id` = 'SYSTEM_TTS_aliyun';
UPDATE `ai_model_provider` SET `name` = 'Custom TTS' WHERE `id` = 'SYSTEM_TTS_custom';
UPDATE `ai_model_provider` SET `name` = 'Mem0AI memory' WHERE `id` = 'SYSTEM_Memory_mem0ai';
UPDATE `ai_model_provider` SET `name` = 'No memory' WHERE `id` = 'SYSTEM_Memory_nomem';
UPDATE `ai_model_provider` SET `name` = 'Local short-term memory (summarized memory)' WHERE `id` = 'SYSTEM_Memory_mem_local_short';
UPDATE `ai_model_provider` SET `name` = 'No intent recognition' WHERE `id` = 'SYSTEM_Intent_nointent';
UPDATE `ai_model_provider` SET `name` = 'Intent recognition by an external LLM' WHERE `id` = 'SYSTEM_Intent_intent_llm';
UPDATE `ai_model_provider` SET `name` = 'Autonomous LLM function calling' WHERE `id` = 'SYSTEM_Intent_function_call';
UPDATE `ai_model_provider` SET `name` = 'Tencent speech recognition' WHERE `id` = 'SYSTEM_ASR_TencentASR';
UPDATE `ai_model_provider` SET `name` = 'Tencent speech synthesis' WHERE `id` = 'SYSTEM_TTS_TencentTTS';
UPDATE `ai_model_provider` SET `name` = 'FunASR server speech recognition' WHERE `id` = 'SYSTEM_ASR_FunASRServer';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Cloud speech recognition' WHERE `id` = 'SYSTEM_ASR_AliyunASR';
UPDATE `ai_model_provider` SET `name` = 'Baidu speech recognition' WHERE `id` = 'SYSTEM_ASR_BaiduASR';
UPDATE `ai_model_provider` SET `name` = 'Volcano bidirectional streaming speech synthesis' WHERE `id` = 'SYSTEM_TTS_HSDSTTS';
UPDATE `ai_model_provider` SET `name` = 'Weather query' WHERE `id` = 'SYSTEM_PLUGIN_WEATHER';
UPDATE `ai_model_provider` SET `name` = 'Server music playback' WHERE `id` = 'SYSTEM_PLUGIN_MUSIC';
UPDATE `ai_model_provider` SET `name` = 'China News Service news' WHERE `id` = 'SYSTEM_PLUGIN_NEWS_CHINANEWS';
UPDATE `ai_model_provider` SET `name` = 'newsnow news aggregation' WHERE `id` = 'SYSTEM_PLUGIN_NEWS_NEWSNOW';
UPDATE `ai_model_provider` SET `name` = 'HomeAssistant music playback' WHERE `id` = 'SYSTEM_PLUGIN_HA_PLAY_MUSIC';
UPDATE `ai_model_provider` SET `name` = 'OpenAI API' WHERE `id` = 'SYSTEM_VLLM_openai';
UPDATE `ai_model_provider` SET `name` = 'OpenAI speech recognition' WHERE `id` = 'SYSTEM_ASR_OpenaiASR';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Cloud speech recognition (streaming)' WHERE `id` = 'SYSTEM_ASR_AliyunStreamASR';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Cloud speech synthesis (streaming)' WHERE `id` = 'SYSTEM_TTS_AliyunStreamTTS';
UPDATE `ai_model_provider` SET `name` = 'Index-TTS-vLLM streaming speech synthesis' WHERE `id` = 'SYSTEM_TTS_IndexStreamTTS';
UPDATE `ai_model_provider` SET `name` = 'VOSK offline speech recognition' WHERE `id` = 'SYSTEM_ASR_VoskASR';
UPDATE `ai_model_provider` SET `name` = 'Minimax streaming speech synthesis' WHERE `id` = 'SYSTEM_TTS_MinimaxStreamTTS';
UPDATE `ai_model_provider` SET `name` = 'Qwen3-ASR-Flash speech recognition' WHERE `id` = 'SYSTEM_ASR_Qwen3Flash';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Bailian streaming speech synthesis' WHERE `id` = 'SYSTEM_TTS_AliBLStreamTTS';
UPDATE `ai_model_provider` SET `name` = 'iFlytek streaming speech synthesis' WHERE `id` = 'SYSTEM_TTS_XunFeiStreamTTS';
UPDATE `ai_model_provider` SET `name` = 'iFlytek streaming speech recognition' WHERE `id` = 'SYSTEM_ASR_XunfeiStream';
UPDATE `ai_model_provider` SET `name` = 'Alibaba Bailian Paraformer real-time ASR' WHERE `id` = 'SYSTEM_ASR_AliyunBLStream';
UPDATE `ai_model_provider` SET `name` = 'Volcano Engine speech recognition (streaming)' WHERE `id` = 'SYSTEM_ASR_DoubaoStreamASR';
UPDATE `ai_model_provider` SET `name` = 'PowerMem memory' WHERE `id` = 'SYSTEM_Memory_powermem';
UPDATE `ai_model_provider` SET `name` = 'Report chat history only (no memory summary)' WHERE `id` = 'SYSTEM_Memory_mem_report_only';
UPDATE `ai_model_provider` SET `name` = 'Web search' WHERE `id` = 'SYSTEM_PLUGIN_WEB_SEARCH';
UPDATE `ai_model_provider` SET `name` = 'Device-to-device call' WHERE `id` = 'SYSTEM_PLUGIN_CALL_DEVICE';
UPDATE `ai_model_provider` SET `name` = 'HomeAssistant device control' WHERE `id` = 'SYSTEM_PLUGIN_HA_STATE';

-- ai_model_provider: field labels inside the `fields` JSON.
-- The whole value is rewritten; keys, types, defaults and options are unchanged, only `label` is translated.
UPDATE `ai_model_provider` SET `fields` = '[{"key": "threshold", "label": "Detection threshold", "type": "number"}, {"key": "model_dir", "label": "Model directory", "type": "string"}, {"key": "min_silence_duration_ms", "label": "Minimum silence duration", "type": "number"}]' WHERE `id` = 'SYSTEM_VAD_SileroVAD';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model_dir", "label": "Model directory", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "language", "label": "Recognition language", "type": "string", "default": "auto"}]' WHERE `id` = 'SYSTEM_ASR_FunASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model_dir", "label": "Model directory", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_SherpaASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appid", "label": "Application ID", "type": "string"}, {"key": "access_token", "label": "Access token", "type": "string"}, {"key": "cluster", "label": "Cluster", "type": "string"}, {"key": "boosting_table_name", "label": "Hot word file name", "type": "string"}, {"key": "correct_table_name", "label": "Replacement word file name", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_DoubaoASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "label": "Base URL", "type": "string"}, {"key": "model_name", "label": "Model name", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "temperature", "label": "Temperature", "type": "number"}, {"key": "max_tokens", "label": "Max tokens", "type": "number"}, {"key": "top_p", "label": "top_p value", "type": "number"}, {"key": "top_k", "label": "top_k value", "type": "number"}, {"key": "frequency_penalty", "label": "Frequency penalty", "type": "number"}]' WHERE `id` = 'SYSTEM_LLM_openai';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "label": "Base URL", "type": "string"}, {"key": "app_id", "label": "Application ID", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "is_no_prompt", "label": "Whether to skip the local prompt", "type": "boolean"}, {"key": "ali_memory_id", "label": "Memory ID", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_AliBL';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model_name", "label": "Model name", "type": "string"}, {"key": "base_url", "label": "Service address", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_ollama';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "label": "Base URL", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "mode", "label": "Conversation mode", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_dify';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "label": "API key", "type": "string"}, {"key": "model_name", "label": "Model name", "type": "string"}, {"key": "http_proxy", "label": "HTTP proxy", "type": "string"}, {"key": "https_proxy", "label": "HTTPS proxy", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_gemini';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "bot_id", "label": "Bot ID", "type": "string"}, {"key": "user_id", "label": "User ID", "type": "string"}, {"key": "personal_access_token", "label": "Personal access token", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_coze';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "label": "Base URL", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "variables", "label": "Variables", "type": "dict", "dict_name": "variables"}]' WHERE `id` = 'SYSTEM_LLM_fastgpt';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model_name", "label": "Model name", "type": "string"}, {"key": "base_url", "label": "Service address", "type": "string"}]' WHERE `id` = 'SYSTEM_LLM_xinference';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "voice", "label": "Voice", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "rate", "label": "Speech rate (-100~100)", "type": "number"}, {"key": "volume", "label": "Volume (0~100)", "type": "number"}, {"key": "pitch", "label": "Pitch (-100~100)", "type": "number"}]' WHERE `id` = 'SYSTEM_TTS_edge';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_url", "label": "API URL", "type": "string"}, {"key": "voice", "label": "Voice", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "authorization", "label": "Authorization", "type": "string"}, {"key": "appid", "label": "Application ID", "type": "string"}, {"key": "access_token", "label": "Access token", "type": "string"}, {"key": "cluster", "label": "Cluster", "type": "string"}, {"key": "speed_ratio", "label": "Speech rate", "type": "number"}, {"key": "volume_ratio", "label": "Volume", "type": "number"}, {"key": "pitch_ratio", "label": "Pitch", "type": "number"}]' WHERE `id` = 'SYSTEM_TTS_doubao';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model", "label": "Model", "type": "string"}, {"key": "voice", "label": "Voice", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "access_token", "label": "Access token", "type": "string"}, {"key": "response_format", "label": "Response format", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_siliconflow';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "voice", "label": "Voice", "type": "string"}, {"key": "access_token", "label": "Access token", "type": "string"}, {"key": "speed", "label": "Speech rate", "type": "number"}, {"key": "loudness_rate", "label": "Volume gain", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "response_format", "label": "Response format", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_cozecn';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "response_format", "label": "Response format", "type": "string"}, {"key": "reference_id", "label": "Reference ID", "type": "string"}, {"key": "reference_audio", "label": "Reference audio", "type": "string"}, {"key": "reference_text", "label": "Reference text", "type": "string"}, {"key": "normalize", "label": "Whether to normalize", "type": "boolean"}, {"key": "max_new_tokens", "label": "Max new tokens", "type": "number"}, {"key": "chunk_length", "label": "Chunk length", "type": "number"}, {"key": "top_p", "label": "top_p value", "type": "number"}, {"key": "repetition_penalty", "label": "Repetition penalty", "type": "number"}, {"key": "temperature", "label": "Temperature", "type": "number"}, {"key": "streaming", "label": "Whether to stream", "type": "boolean"}, {"key": "use_memory_cache", "label": "Whether to use the memory cache", "type": "string"}, {"key": "seed", "label": "Seed", "type": "number"}, {"key": "channels", "label": "Number of channels", "type": "number"}, {"key": "rate", "label": "Sample rate", "type": "number"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "api_url", "label": "API URL", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_fishspeech';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "url", "label": "Service address", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "text_lang", "label": "Text language", "type": "string"}, {"key": "ref_audio_path", "label": "Reference audio path", "type": "string"}, {"key": "prompt_text", "label": "Prompt text", "type": "string"}, {"key": "prompt_lang", "label": "Prompt language", "type": "string"}, {"key": "top_k", "label": "top_k value", "type": "number"}, {"key": "top_p", "label": "top_p value", "type": "number"}, {"key": "temperature", "label": "Temperature", "type": "number"}, {"key": "text_split_method", "label": "Text split method", "type": "string"}, {"key": "batch_size", "label": "Batch size", "type": "number"}, {"key": "batch_threshold", "label": "Batch threshold", "type": "number"}, {"key": "split_bucket", "label": "Whether to split into buckets", "type": "boolean"}, {"key": "return_fragment", "label": "Whether to return fragments", "type": "boolean"}, {"key": "speed_factor", "label": "Speed factor", "type": "number"}, {"key": "streaming_mode", "label": "Whether to use streaming mode", "type": "boolean"}, {"key": "seed", "label": "Seed", "type": "number"}, {"key": "parallel_infer", "label": "Whether to infer in parallel", "type": "boolean"}, {"key": "repetition_penalty", "label": "Repetition penalty", "type": "number"}, {"key": "aux_ref_audio_paths", "label": "Auxiliary reference audio paths", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_gpt_sovits_v2';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "url", "label": "Service address", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "text_language", "label": "Text language", "type": "string"}, {"key": "refer_wav_path", "label": "Reference audio path", "type": "string"}, {"key": "prompt_language", "label": "Prompt language", "type": "string"}, {"key": "prompt_text", "label": "Prompt text", "type": "string"}, {"key": "top_k", "label": "top_k value", "type": "number"}, {"key": "top_p", "label": "top_p value", "type": "number"}, {"key": "temperature", "label": "Temperature", "type": "number"}, {"key": "cut_punc", "label": "Split punctuation", "type": "string"}, {"key": "speed", "label": "Speed", "type": "number"}, {"key": "inp_refs", "label": "Input references", "type": "string"}, {"key": "sample_steps", "label": "Sample steps", "type": "number"}, {"key": "if_sr", "label": "Whether to use SR", "type": "boolean"}]' WHERE `id` = 'SYSTEM_TTS_gpt_sovits_v3';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "appkey", "label": "Application key", "type": "string"}, {"key": "token", "label": "Access token", "type": "string"}, {"key": "voice", "label": "Voice", "type": "string"}, {"key": "access_key_id", "label": "Access key ID", "type": "string"}, {"key": "access_key_secret", "label": "Access key secret", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_aliyun';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "label": "API key", "type": "string"}, {"key": "api_url", "label": "API URL", "type": "string"}, {"key": "model", "label": "Model", "type": "string"}, {"key": "voice", "label": "Voice", "type": "string"}, {"key": "speed", "label": "Speed", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_openai';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "url", "label": "Service address", "type": "string"}, {"key": "method", "label": "Request method", "type": "string"}, {"key": "params", "label": "Request parameters", "type": "dict"}, {"key": "headers", "label": "Request headers", "type": "dict"}, {"key": "format", "label": "Audio format", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_custom';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "label": "API key", "type": "string"}]' WHERE `id` = 'SYSTEM_Memory_mem0ai';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "llm", "label": "LLM model", "type": "string"}]' WHERE `id` = 'SYSTEM_Memory_mem_local_short';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "llm", "label": "Referenced LLM model", "type": "string"}]' WHERE `id` = 'SYSTEM_Intent_intent_llm';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appid", "label": "Application ID", "type": "string"}, {"key": "secret_id", "label": "Secret ID", "type": "string"}, {"key": "secret_key", "label": "Secret Key", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_TencentASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appid", "label": "Application ID", "type": "string"}, {"key": "secret_id", "label": "Secret ID", "type": "string"}, {"key": "secret_key", "label": "Secret Key", "type": "string"}, {"key": "format", "label": "Audio format", "type": "string"}, {"key": "speed", "label": "Speech rate", "type": "number"}, {"key": "volume", "label": "Volume", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "voice", "label": "Voice ID", "type": "string"}, {"key": "region", "label": "Region", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_TencentTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "host", "type": "string", "label": "Service address"}, {"key": "port", "type": "number", "label": "Port"}, {"key": "type", "type": "string", "label": "Service type"}, {"key": "is_ssl", "type": "boolean", "label": "Whether to use SSL"}, {"key": "api_key", "type": "string", "label": "API key"}, {"key": "output_dir", "type": "string", "label": "Output directory"}]' WHERE `id` = 'SYSTEM_ASR_FunASRServer';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appkey", "label": "Application AppKey", "type": "string"}, {"key": "token", "label": "Temporary token", "type": "string"}, {"key": "access_key_id", "label": "AccessKey ID", "type": "string"}, {"key": "access_key_secret", "label": "AccessKey Secret", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_AliyunASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "app_id", "label": "Application AppID", "type": "string"}, {"key": "api_key", "label": "API Key", "type": "string"}, {"key": "secret_key", "label": "Secret Key", "type": "string"}, {"key": "dev_pid", "label": "Language parameter", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_BaiduASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "ws_url", "type": "string", "label": "WebSocket URL"}, {"key": "appid", "type": "string", "label": "Application ID"}, {"key": "access_token", "type": "string", "label": "Access token"}, {"key": "resource_id", "type": "string", "label": "Resource ID"}, {"key": "speaker", "type": "string", "label": "Default voice"}, {"key": "enable_ws_reuse", "type": "boolean", "label": "Whether to enable connection reuse", "default": true}, {"key": "audio_params", "type": "dict", "label": "Audio output configuration"}, {"key": "additions", "type": "dict", "label": "Advanced text processing configuration"}, {"key": "mix_speaker", "type": "dict", "label": "Voice mixing control configuration"}]' WHERE `id` = 'SYSTEM_TTS_HSDSTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "label": "Base URL", "type": "string"}, {"key": "model_name", "label": "Model name", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}]' WHERE `id` = 'SYSTEM_VLLM_openai';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "type": "string", "label": "Base URL"}, {"key": "model_name", "type": "string", "label": "Model name"}, {"key": "api_key", "type": "string", "label": "API key"}, {"key": "output_dir", "type": "string", "label": "Output directory"}]' WHERE `id` = 'SYSTEM_ASR_OpenaiASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appkey", "label": "Application AppKey", "type": "string"}, {"key": "token", "label": "Temporary token", "type": "string"}, {"key": "access_key_id", "label": "AccessKey ID", "type": "string"}, {"key": "access_key_secret", "label": "AccessKey Secret", "type": "string"}, {"key": "host", "label": "Service address", "type": "string"}, {"key": "max_sentence_silence", "label": "Sentence break detection time", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_AliyunStreamASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appkey", "label": "Application AppKey", "type": "string"}, {"key": "token", "label": "Temporary token", "type": "string"}, {"key": "access_key_id", "label": "AccessKey ID", "type": "string"}, {"key": "access_key_secret", "label": "AccessKey Secret", "type": "string"}, {"key": "host", "label": "Service address", "type": "string"}, {"key": "voice", "label": "Default voice", "type": "string"}, {"key": "format", "label": "Audio format", "type": "string"}, {"key": "volume", "label": "Volume", "type": "number"}, {"key": "speech_rate", "label": "Speech rate", "type": "number"}, {"key": "pitch_rate", "label": "Pitch", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_AliyunStreamTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_url", "label": "API service address", "type": "string"}, {"key": "voice", "label": "Default voice", "type": "string"}, {"key": "audio_format", "label": "Audio format", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_IndexStreamTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "protocol", "label": "Protocol type", "type": "string", "options": ["websocket"]}, {"key": "url", "label": "Service address", "type": "string"}, {"key": "spk_id", "label": "Voice", "type": "int"}, {"key": "sample_rate", "label": "Sample rate", "type": "float"}, {"key": "speed", "label": "Speech rate", "type": "float"}, {"key": "volume", "label": "Volume", "type": "float"}, {"key": "save_path", "label": "Save path", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_PaddleSpeechTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "model_path", "type": "string", "label": "Model path"}, {"key": "output_dir", "type": "string", "label": "Output directory"}]' WHERE `id` = 'SYSTEM_ASR_VoskASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "group_id", "label": "Group ID", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "model", "label": "Model", "type": "string"}, {"key": "voice_id", "label": "Voice ID", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "voice_setting", "label": "Voice settings", "type": "dict"}, {"key": "pronunciation_dict", "label": "Pronunciation dictionary", "type": "dict"}, {"key": "audio_setting", "label": "Audio settings", "type": "dict"}, {"key": "timber_weights", "label": "Voice weights", "type": "string"}]' WHERE `id` = 'SYSTEM_TTS_MinimaxStreamTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "label": "API key", "type": "password"}, {"key": "base_url", "label": "Service address", "type": "string"}, {"key": "model_name", "label": "Model name", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_Qwen3Flash';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "type": "string", "label": "API key"}, {"key": "ws_url", "type": "string", "label": "WebSocket URL (including Workspace ID)", "default": "wss://dashscope.aliyuncs.com/api-ws/v1/inference/"}, {"key": "output_dir", "type": "string", "label": "Output directory"}, {"key": "model", "type": "string", "label": "Model"}, {"key": "voice", "type": "string", "label": "Voice"}, {"key": "format", "type": "string", "label": "Audio format"}, {"key": "sample_rate", "type": "number", "label": "Sample rate"}, {"key": "volume", "type": "number", "label": "Volume"}, {"key": "rate", "type": "number", "label": "Speech rate"}, {"key": "pitch", "type": "number", "label": "Pitch"}]' WHERE `id` = 'SYSTEM_TTS_AliBLStreamTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "app_id", "label": "APP_ID", "type": "string"}, {"key": "api_secret", "label": "API_Secret", "type": "string"}, {"key": "api_key", "label": "API key", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}, {"key": "voice", "label": "Voice", "type": "string"}, {"key": "format", "label": "Audio format", "type": "string"}, {"key": "volume", "label": "Volume", "type": "number"}, {"key": "speed", "label": "Speech rate", "type": "number"}, {"key": "pitch", "label": "Pitch", "type": "number"}, {"key": "oral_level", "label": "Colloquial level", "type": "number"}, {"key": "spark_assist", "label": "Whether to use colloquial style", "type": "number"}, {"key": "stop_split", "label": "Server-side sentence splitting", "type": "number"}, {"key": "remain", "label": "Keep written-style wording", "type": "number"}]' WHERE `id` = 'SYSTEM_TTS_XunFeiStreamTTS';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "app_id", "label": "Application ID", "type": "string"}, {"key": "api_key", "label": "API_KEY", "type": "password"}, {"key": "api_secret", "label": "API_SECRET", "type": "password"}, {"key": "domain", "label": "Recognition domain", "type": "string"}, {"key": "language", "label": "Recognition language", "type": "string"}, {"key": "accent", "label": "Dialect", "type": "string"}, {"key": "dwa", "label": "Dynamic correction", "type": "string"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_XunfeiStream';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "base_url", "type": "string", "label": "Service address"}, {"key": "api_key", "type": "string", "label": "API key"}]' WHERE `id` = 'SYSTEM_RAG_ragflow';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "api_key", "label": "API key", "type": "password"}, {"key": "model", "label": "Model name", "type": "string"}, {"key": "format", "label": "Audio format", "type": "string"}, {"key": "sample_rate", "label": "Sample rate", "type": "number"}, {"key": "output_dir", "label": "Output directory", "type": "string"}]' WHERE `id` = 'SYSTEM_ASR_AliyunBLStream';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "appid", "type": "string", "label": "Application ID"}, {"key": "access_token", "type": "string", "label": "Access token"}, {"key": "boosting_table_name", "type": "string", "label": "Hot word file name"}, {"key": "correct_table_name", "type": "string", "label": "Replacement word file name"}, {"key": "output_dir", "type": "string", "label": "Output directory"}, {"key": "end_window_size", "type": "number", "label": "Silence detection duration (ms)"}, {"key": "enable_multilingual", "type": "boolean", "label": "Whether to enable multilingual recognition mode"}, {"key": "language", "type": "string", "label": "Specified language code"}, {"key": "resource_id", "type": "string", "label": "Resource ID"}]' WHERE `id` = 'SYSTEM_ASR_DoubaoStreamASR';
UPDATE `ai_model_provider` SET `fields` = '[{"key": "enable_user_profile", "label": "Enable user profile", "type": "boolean"}, {"key": "llm_provider", "label": "LLM provider", "type": "string"}, {"key": "llm_api_key", "label": "LLM API key", "type": "string"}, {"key": "llm_model", "label": "LLM model", "type": "string"}, {"key": "openai_base_url", "label": "OpenAI base URL", "type": "string"}, {"key": "embedding_provider", "label": "Embedding provider", "type": "string"}, {"key": "embedding_api_key", "label": "Embedding API key", "type": "string"}, {"key": "embedding_model", "label": "Embedding model", "type": "string"}, {"key": "embedding_openai_base_url", "label": "Embedding OpenAI base URL", "type": "string"}, {"key": "embedding_dims", "label": "Embedding dimensions", "type": "integer"}, {"key": "vector_store", "label": "Vector store configuration (JSON)", "type": "dict"}]' WHERE `id` = 'SYSTEM_Memory_powermem';

-- ai_model_provider: plugin field labels. Plugin defaults hold deployment-specific values
-- (API keys, hosts, cities), so only the label of each field is set, and only when the
-- field at that position still has the expected key.
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[0].label', 'Weather plugin API key') WHERE `id` = 'SYSTEM_PLUGIN_WEATHER' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[0].key')) = 'api_key';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[1].label', 'Default city to query') WHERE `id` = 'SYSTEM_PLUGIN_WEATHER' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[1].key')) = 'default_location';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[2].label', 'Developer API Host') WHERE `id` = 'SYSTEM_PLUGIN_WEATHER' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[2].key')) = 'api_host';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[0].label', 'Default RSS feed') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_CHINANEWS' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[0].key')) = 'default_rss_url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[1].label', 'Society news RSS URL') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_CHINANEWS' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[1].key')) = 'society_rss_url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[2].label', 'World news RSS URL') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_CHINANEWS' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[2].key')) = 'world_rss_url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[3].label', 'Finance news RSS URL') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_CHINANEWS' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[3].key')) = 'finance_rss_url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[0].label', 'API URL') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_NEWSNOW' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[0].key')) = 'url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[1].label', 'News source configuration') WHERE `id` = 'SYSTEM_PLUGIN_NEWS_NEWSNOW' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[1].key')) = 'news_sources';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[0].label', 'Search provider: metaso / tavily / serply / outcrawl') WHERE `id` = 'SYSTEM_PLUGIN_WEB_SEARCH' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[0].key')) = 'provider';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[1].label', 'Tool description') WHERE `id` = 'SYSTEM_PLUGIN_WEB_SEARCH' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[1].key')) = 'description';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[2].label', 'Number of results') WHERE `id` = 'SYSTEM_PLUGIN_WEB_SEARCH' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[2].key')) = 'max_results';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[0].label', 'HA server address') WHERE `id` = 'SYSTEM_PLUGIN_HA_STATE' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[0].key')) = 'base_url';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[1].label', 'HA API access token') WHERE `id` = 'SYSTEM_PLUGIN_HA_STATE' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[1].key')) = 'api_key';
UPDATE `ai_model_provider` SET `fields` = JSON_SET(`fields`, '$[2].label', 'Device list (name,entity ID;...)') WHERE `id` = 'SYSTEM_PLUGIN_HA_STATE' AND JSON_UNQUOTE(JSON_EXTRACT(`fields`, '$[2].key')) = 'devices';

-- ai_model_config: model display names
UPDATE `ai_model_config` SET `model_name` = 'Voice activity detection' WHERE `id` = 'VAD_SileroVAD';
UPDATE `ai_model_config` SET `model_name` = 'FunASR speech recognition' WHERE `id` = 'ASR_FunASR';
UPDATE `ai_model_config` SET `model_name` = 'Sherpa speech recognition' WHERE `id` = 'ASR_SherpaASR';
UPDATE `ai_model_config` SET `model_name` = 'Doubao speech recognition' WHERE `id` = 'ASR_DoubaoASR';
UPDATE `ai_model_config` SET `model_name` = 'Tencent speech recognition' WHERE `id` = 'ASR_TencentASR';
UPDATE `ai_model_config` SET `model_name` = 'Zhipu AI' WHERE `id` = 'LLM_ChatGLMLLM';
UPDATE `ai_model_config` SET `model_name` = 'Ollama local model' WHERE `id` = 'LLM_OllamaLLM';
UPDATE `ai_model_config` SET `model_name` = 'Tongyi Qianwen' WHERE `id` = 'LLM_AliLLM';
UPDATE `ai_model_config` SET `model_name` = 'Bailian agent application' WHERE `id` = 'LLM_AliAppLLM';
UPDATE `ai_model_config` SET `model_name` = 'Doubao LLM' WHERE `id` = 'LLM_DoubaoLLM';
UPDATE `ai_model_config` SET `model_name` = 'Google Gemini' WHERE `id` = 'LLM_GeminiLLM';
UPDATE `ai_model_config` SET `model_name` = 'Xinference large model' WHERE `id` = 'LLM_XinferenceLLM';
UPDATE `ai_model_config` SET `model_name` = 'Xinference small model' WHERE `id` = 'LLM_XinferenceSmallLLM';
UPDATE `ai_model_config` SET `model_name` = 'Edge speech synthesis' WHERE `id` = 'TTS_EdgeTTS';
UPDATE `ai_model_config` SET `model_name` = 'Doubao speech synthesis' WHERE `id` = 'TTS_DoubaoTTS';
UPDATE `ai_model_config` SET `model_name` = 'SiliconFlow speech synthesis' WHERE `id` = 'TTS_CosyVoiceSiliconflow';
UPDATE `ai_model_config` SET `model_name` = 'Coze CN speech synthesis' WHERE `id` = 'TTS_CozeCnTTS';
UPDATE `ai_model_config` SET `model_name` = 'FishSpeech speech synthesis' WHERE `id` = 'TTS_FishSpeech';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Cloud speech synthesis' WHERE `id` = 'TTS_AliyunTTS';
UPDATE `ai_model_config` SET `model_name` = '302AI speech synthesis' WHERE `id` = 'TTS_TTS302AI';
UPDATE `ai_model_config` SET `model_name` = 'OpenAI speech synthesis' WHERE `id` = 'TTS_OpenAITTS';
UPDATE `ai_model_config` SET `model_name` = 'Custom speech synthesis' WHERE `id` = 'TTS_CustomTTS';
UPDATE `ai_model_config` SET `model_name` = 'Tencent speech synthesis' WHERE `id` = 'TTS_TencentTTS';
UPDATE `ai_model_config` SET `model_name` = 'No memory' WHERE `id` = 'Memory_nomem';
UPDATE `ai_model_config` SET `model_name` = 'Local short-term memory (summarized memory)' WHERE `id` = 'Memory_mem_local_short';
UPDATE `ai_model_config` SET `model_name` = 'Mem0AI memory' WHERE `id` = 'Memory_mem0ai';
UPDATE `ai_model_config` SET `model_name` = 'No intent recognition' WHERE `id` = 'Intent_nointent';
UPDATE `ai_model_config` SET `model_name` = 'Intent recognition by an external LLM' WHERE `id` = 'Intent_intent_llm';
UPDATE `ai_model_config` SET `model_name` = 'Autonomous LLM function calling' WHERE `id` = 'Intent_function_call';
UPDATE `ai_model_config` SET `model_name` = 'Volcano Engine edge LLM gateway' WHERE `id` = 'LLM_VolcesAiGatewayLLM';
UPDATE `ai_model_config` SET `model_name` = 'Volcano Engine edge LLM gateway' WHERE `id` = 'TTS_VolcesAiGatewayTTS';
UPDATE `ai_model_config` SET `model_name` = 'FunASR server speech recognition' WHERE `id` = 'ASR_FunASRServer';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Cloud speech recognition' WHERE `id` = 'ASR_AliyunASR';
UPDATE `ai_model_config` SET `model_name` = 'Baidu speech recognition' WHERE `id` = 'ASR_BaiduASR';
UPDATE `ai_model_config` SET `model_name` = 'Volcano Engine (streaming)' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'Zhipu vision AI' WHERE `id` = 'VLLM_ChatGLMVLLM';
UPDATE `ai_model_config` SET `model_name` = 'Doubao speech recognition (streaming)' WHERE `id` = 'ASR_DoubaoStreamASR';
UPDATE `ai_model_config` SET `model_name` = 'Qianwen vision model' WHERE `id` = 'VLLM_QwenVLVLLM';
UPDATE `ai_model_config` SET `model_name` = 'OpenAI speech recognition' WHERE `id` = 'ASR_OpenaiASR';
UPDATE `ai_model_config` SET `model_name` = 'Groq speech recognition' WHERE `id` = 'ASR_GroqASR';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Cloud speech recognition (streaming)' WHERE `id` = 'ASR_AliyunStreamASR';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Cloud (streaming)' WHERE `id` = 'TTS_AliyunStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'IndexTTS (streaming)' WHERE `id` = 'TTS_IndexStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'PaddleSpeech (streaming)' WHERE `id` = 'TTS_PaddleSpeechTTS';
UPDATE `ai_model_config` SET `model_name` = 'VOSK offline speech recognition' WHERE `id` = 'ASR_VoskASR';
UPDATE `ai_model_config` SET `model_name` = 'Minimax (streaming)' WHERE `id` = 'TTS_MinimaxStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'Qwen3Flash speech recognition' WHERE `id` = 'ASR_Qwen3Flash';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Bailian (streaming)' WHERE `id` = 'TTS_AliBLStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'iFlytek (streaming)' WHERE `id` = 'TTS_XunFeiStreamTTS';
UPDATE `ai_model_config` SET `model_name` = 'iFlytek speech recognition (streaming)' WHERE `id` = 'ASR_XunfeiStream';
UPDATE `ai_model_config` SET `model_name` = 'iFlytek Spark cognitive LLM' WHERE `id` = 'LLM_XunfeiSparkLLM';
UPDATE `ai_model_config` SET `model_name` = 'Alibaba Bailian Paraformer real-time ASR' WHERE `id` = 'ASR_AliyunBLStream';
UPDATE `ai_model_config` SET `model_name` = 'PowerMem memory' WHERE `id` = 'Memory_powermem';
UPDATE `ai_model_config` SET `model_name` = 'Report chat history only (no memory summary)' WHERE `id` = 'Memory_mem_report_only';
UPDATE `ai_model_config` SET `model_name` = 'Doubao speech synthesis 2.0 (streaming)' WHERE `id` = 'TTS_HSDSTTS_V2';
UPDATE `ai_model_config` SET `model_name` = 'Doubao speech recognition 2.0 (streaming)' WHERE `id` = 'ASR_DoubaoStreamASRV2';

-- ai_model_config: configuration notes shown in the model dialog
UPDATE `ai_model_config` SET `remark` = 'SileroVAD configuration notes:
1. Uses the SileroVAD model for voice activity detection
2. Local inference, no network connection required
3. The model files must be downloaded to the models/snakers4_silero-vad directory
4. Configurable parameters:
   - threshold: 0.5 (voice detection threshold)
   - min_silence_duration_ms: 700 (minimum silence duration, in milliseconds)
5. If pauses in speech are relatively long, increase min_silence_duration_ms accordingly' WHERE `id` = 'VAD_SileroVAD';
UPDATE `ai_model_config` SET `remark` = 'FunASR local model configuration notes:
1. The model files must be downloaded to the xiaozhi-server/models/SenseVoiceSmall directory
2. Supports Chinese, Japanese, Korean and Cantonese speech recognition
3. Local inference, no network connection required
4. Files to be recognized are saved in the tmp/ directory
5. The "Recognition language" field controls the recognized language: auto = automatic detection; to recognize Chinese only, set it to zh (en = English, ja = Japanese, ko = Korean, yue = Cantonese).' WHERE `id` = 'ASR_FunASR';
UPDATE `ai_model_config` SET `remark` = 'SherpaASR configuration notes:
1. The model files are downloaded automatically at runtime to the models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17 directory
2. Supports multiple languages such as Chinese, English, Japanese, Korean and Cantonese
3. Local inference, no network connection required
4. Output files are saved in the tmp/ directory' WHERE `id` = 'ASR_SherpaASR';
UPDATE `ai_model_config` SET `remark` = 'Doubao ASR configuration notes:
1. The difference between Doubao ASR and Doubao (streaming) ASR: Doubao ASR is billed per call, Doubao (streaming) ASR is billed by duration
2. Generally, per-call billing is cheaper, but Doubao (streaming) ASR uses large-model technology and gives better results
3. You need to create an application in the Volcano Engine console and obtain the appid and access_token
4. Supports Chinese speech recognition
5. Requires a network connection
6. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://console.volcengine.com/speech/app
2. Create a new application
3. Obtain the appid and access_token
4. Fill them into the configuration file
To set hot words, see: https://www.volcengine.com/docs/6561/155738
' WHERE `id` = 'ASR_DoubaoASR';
UPDATE `ai_model_config` SET `remark` = 'Tencent ASR configuration notes:
1. You need to create an application in the Tencent Cloud console and obtain the appid, secret_id and secret_key
2. Supports Chinese speech recognition
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://console.cloud.tencent.com/cam/capi to obtain the keys
2. Visit https://console.cloud.tencent.com/asr/resourcebundle to claim the free resources
3. Obtain the appid, secret_id and secret_key
4. Fill them into the configuration file' WHERE `id` = 'ASR_TencentASR';
UPDATE `ai_model_config` SET `remark` = 'ChatGLM configuration notes:
1. Visit https://bigmodel.cn/usercenter/proj-mgmt/apikeys
2. Register and obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'LLM_ChatGLMLLM';
UPDATE `ai_model_config` SET `remark` = 'Ollama configuration notes:
1. Install the Ollama service
2. Run the command: ollama pull qwen2.5
3. Make sure the service is running at http://localhost:11434' WHERE `id` = 'LLM_OllamaLLM';
UPDATE `ai_model_config` SET `remark` = 'Tongyi Qianwen configuration notes:
1. Visit https://bailian.console.aliyun.com/?apiKey=1#/api-key
2. Obtain an API key
3. Fill it into the configuration file; the current configuration uses the qwen-flash model
4. Supports custom parameters: temperature=0.7, max_tokens=500, top_p=1, top_k=50' WHERE `id` = 'LLM_AliLLM';
UPDATE `ai_model_config` SET `remark` = 'Tongyi Bailian configuration notes:
1. Visit https://bailian.console.aliyun.com/?apiKey=1#/api-key
2. Obtain the app_id and api_key
3. Fill them into the configuration file' WHERE `id` = 'LLM_AliAppLLM';
UPDATE `ai_model_config` SET `remark` = 'Doubao LLM configuration notes:
1. Visit https://console.volcengine.com/ark/region:ark+cn-beijing/openManagement
2. Activate the Doubao-Seed-2.0-Lite service
3. Visit https://console.volcengine.com/ark/region:ark+cn-beijing/apiKey to obtain an API key
4. Fill it into the configuration file
5. doubao-seed-2-0-lite-260215 is currently recommended
Note: there is a free quota of 500000 tokens' WHERE `id` = 'LLM_DoubaoLLM';
UPDATE `ai_model_config` SET `remark` = 'DeepSeek configuration notes:
1. Visit https://platform.deepseek.com/
2. Register and obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'LLM_DeepSeekLLM';
UPDATE `ai_model_config` SET `remark` = 'Dify configuration notes:
1. Visit https://cloud.dify.ai/
2. Register and obtain an API key
3. Fill it into the configuration file
4. Supports multiple conversation modes: workflows/run, chat-messages, completion-messages
5. The role definition set on this platform will not take effect; it must be set in the Dify console
Note: a locally deployed Dify API is recommended; access to the public cloud API may be restricted in some regions of mainland China' WHERE `id` = 'LLM_DifyLLM';
UPDATE `ai_model_config` SET `remark` = 'Gemini configuration notes:
1. Uses the Google Gemini API service
2. The current configuration uses the gemini-2.0-flash model
3. Requires a network connection
4. Supports configuring a proxy
Application steps:
1. Visit https://aistudio.google.com/apikey
2. Create an API key
3. Fill it into the configuration file
Note: if used within mainland China, please comply with the "Interim Measures for the Management of Generative Artificial Intelligence Services"' WHERE `id` = 'LLM_GeminiLLM';
UPDATE `ai_model_config` SET `remark` = 'Coze configuration notes:
1. Uses the Coze platform service
2. Requires bot_id, user_id and a personal access token
3. Requires a network connection
Application steps:
1. Visit https://www.coze.cn/open/oauth/pats
2. Obtain a personal access token
3. Work out the bot_id and user_id manually
4. Fill them into the configuration file' WHERE `id` = 'LLM_CozeLLM';
UPDATE `ai_model_config` SET `remark` = 'LM Studio configuration notes:
1. Uses a locally deployed LM Studio service
2. The current configuration uses the deepseek-r1-distill-llama-8b@q4_k_m model
3. Local inference, no network connection required
4. The model must be downloaded in advance
Deployment steps:
1. Install LM Studio
2. Download the model from the community
3. Make sure the service is running at http://localhost:1234/v1' WHERE `id` = 'LLM_LMStudioLLM';
UPDATE `ai_model_config` SET `remark` = 'FastGPT configuration notes:
1. Uses the FastGPT platform service
2. Requires a network connection
3. The prompt in the configuration file has no effect; it must be set in the FastGPT console
4. Supports custom variables
Application steps:
1. Visit https://cloud.tryfastgpt.ai/account/apikey
2. Obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'LLM_FastgptLLM';
UPDATE `ai_model_config` SET `remark` = 'Xinference configuration notes:
1. Uses a locally deployed Xinference service
2. The current configuration uses the qwen2.5:72b-AWQ model
3. Local inference, no network connection required
4. The corresponding model must be started in advance
Deployment steps:
1. Install Xinference
2. Start the service and load the model
3. Make sure the service is running at http://localhost:9997' WHERE `id` = 'LLM_XinferenceLLM';
UPDATE `ai_model_config` SET `remark` = 'Xinference small model configuration notes:
1. Uses a locally deployed Xinference service
2. The current configuration uses the qwen2.5:3b-AWQ model
3. Local inference, no network connection required
4. Used for intent recognition
Deployment steps:
1. Install Xinference
2. Start the service and load the model
3. Make sure the service is running at http://localhost:9997' WHERE `id` = 'LLM_XinferenceSmallLLM';
UPDATE `ai_model_config` SET `remark` = 'EdgeTTS configuration notes:
1. Uses the Microsoft Edge TTS service
2. Supports multiple languages and voices
3. Free to use, no registration required
4. Requires a network connection
5. Output files are saved in the tmp/ directory
6. Speech rate: -100~100, 0 is normal speed
7. Volume: 0~100, 50 is normal volume
8. Pitch: -100~100, 0 is normal pitch' WHERE `id` = 'TTS_EdgeTTS';
UPDATE `ai_model_config` SET `remark` = 'Doubao TTS configuration notes:
1. Visit https://console.volcengine.com/speech/service/8
2. You need to create an application in the Volcano Engine console and obtain the appid and access_token
3. You must pay for the Volcano Engine speech service; the starting price is 30 yuan, which already gives 100 concurrent connections. The free tier has only 2 concurrent connections and will frequently report tts errors
4. After purchasing the service and then the free voices, you may have to wait about half an hour before they can be used.
5. Fill them into the configuration file' WHERE `id` = 'TTS_DoubaoTTS';
UPDATE `ai_model_config` SET `remark` = 'SiliconFlow TTS configuration notes:
1. Visit https://cloud.siliconflow.cn/account/ak
2. Register and obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'TTS_CosyVoiceSiliconflow';
UPDATE `ai_model_config` SET `remark` = 'Coze CN speech synthesis configuration notes:
1. Visit https://www.coze.cn/ to register and log in
2. Create an application and obtain the access_token
3. Choose a suitable voice ID
Audio parameters:
- response_format: audio format, supports pcm, wav, mp3
- speed: speech rate, range 0.5~2, default 1
- loudness_rate: volume gain, range -50~100, default 0' WHERE `id` = 'TTS_CozeCnTTS';
UPDATE `ai_model_config` SET `remark` = 'FishSpeech configuration notes:
1. The FishSpeech service must be deployed locally
2. Supports custom voices
3. Local inference, no network connection required
4. Output files are saved in the tmp/ directory
5. See the tutorial at https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/fish-speech-integration.md' WHERE `id` = 'TTS_FishSpeech';
UPDATE `ai_model_config` SET `remark` = 'GPT-SoVITS V2 configuration notes:
1. The GPT-SoVITS service must be deployed locally
2. Supports custom voice cloning
3. Local inference, no network connection required
4. Output files are saved in the tmp/ directory
Deployment steps:
1. Example command to run the service: python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/demo.yaml' WHERE `id` = 'TTS_GPT_SOVITS_V2';
UPDATE `ai_model_config` SET `remark` = 'GPT-SoVITS V3 configuration notes:
1. The GPT-SoVITS V3 service must be deployed locally
2. Supports custom voice cloning
3. Local inference, no network connection required
4. Output files are saved in the tmp/ directory' WHERE `id` = 'TTS_GPT_SOVITS_V3';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Cloud TTS configuration notes:
1. You need to activate the Intelligent Speech Interaction service on the Alibaba Cloud platform
2. Supports multiple voices; the current configuration uses xiaoyun
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://nls-portal.console.aliyun.com/ to activate the service
2. Visit https://nls-portal.console.aliyun.com/applist to obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain the token
4. Fill them into the configuration file
Note: the token is temporary and valid for 24 hours; for long-term use, configure access_key_id and access_key_secret' WHERE `id` = 'TTS_AliyunTTS';
UPDATE `ai_model_config` SET `remark` = '302AI TTS configuration notes:
1. You need to create an account on the 302 platform and obtain an API key
2. Supports multiple voices; the current configuration uses the Wanwan Xiaohe voice
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://dash.302.ai/ to register an account
2. Visit https://dash.302.ai/apis/list to obtain an API key
3. Fill it into the configuration file
Price: $35 per million characters' WHERE `id` = 'TTS_TTS302AI';
UPDATE `ai_model_config` SET `remark` = 'OpenAI TTS configuration notes:
1. You need to obtain an API key on the OpenAI platform
2. Supports multiple voices; the current configuration uses onyx
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://platform.openai.com/api-keys to obtain an API key
2. Fill it into the configuration file
Note: a proxy is required for access from mainland China' WHERE `id` = 'TTS_OpenAITTS';
UPDATE `ai_model_config` SET `remark` = 'Custom TTS configuration notes:
1. A custom TTS API service; the request parameters can be customized, so many TTS services can be connected
2. A locally deployed KokoroTTS is used as the example
3. If you only have a CPU, run: docker run -p 8880:8880 ghcr.io/remsky/kokoro-fastapi-cpu:latest
4. If you only have a GPU, run: docker run --gpus all -p 8880:8880 ghcr.io/remsky/kokoro-fastapi-gpu:latest
Configuration notes:
1. Configure the request parameters in params, in JSON format
   For example, KokoroTTS: { "input": "{prompt_text}", "speed": 1, "voice": "zm_yunxi", "stream": true, "download_format": "mp3", "response_format": "mp3", "return_download_link": true }
2. Configure the request headers in headers
3. Set the returned audio format' WHERE `id` = 'TTS_CustomTTS';
UPDATE `ai_model_config` SET `remark` = 'Tencent TTS configuration notes:
1. You need to activate the Intelligent Speech Interaction service on the Tencent Cloud platform
2. Supports multiple voices; the current configuration uses 101001
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://console.cloud.tencent.com/cam/capi to obtain the keys
2. Visit https://console.cloud.tencent.com/tts/resourcebundle to claim the free resources
3. Create a new application
4. Obtain the appid, secret_id and secret_key
5. Fill them into the configuration file
Audio parameters:
- format: audio format, supports pcm, wav, mp3
- speed: speech rate, range -2~6, default 0
- volume: volume, range -10~10, default 0' WHERE `id` = 'TTS_TencentTTS';
UPDATE `ai_model_config` SET `remark` = 'No-memory configuration notes:
1. Conversation history is not saved
2. Every conversation is independent
3. No additional configuration required
4. Suitable for scenarios with high privacy requirements' WHERE `id` = 'Memory_nomem';
UPDATE `ai_model_config` SET `remark` = 'Local short-term memory configuration notes:
1. Uses local storage to save conversation history
2. Summarizes the conversation content with the llm of selected_module
3. Data is kept locally and is not uploaded to a server
4. Suitable for privacy-conscious scenarios
5. No additional configuration required' WHERE `id` = 'Memory_mem_local_short';
UPDATE `ai_model_config` SET `remark` = 'Mem0AI memory configuration notes:
1. Uses the Mem0AI service to save conversation history
2. Requires an API key
3. Requires a network connection
4. 1000 free calls per month
Application steps:
1. Visit https://app.mem0.ai/dashboard/api-keys
2. Obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'Memory_mem0ai';
UPDATE `ai_model_config` SET `remark` = 'No-intent-recognition configuration notes:
1. No intent recognition is performed
2. All conversations are passed directly to the LLM
3. No additional configuration required
4. Suitable for simple conversation scenarios' WHERE `id` = 'Intent_nointent';
UPDATE `ai_model_config` SET `remark` = 'LLM intent recognition configuration notes:
1. Uses a separate LLM for intent recognition
2. Uses the model of selected_module.LLM by default
3. A separate LLM can be configured (such as the free ChatGLMLLM)
4. Highly generic, but increases processing time
Configuration notes:
1. Specify the LLM model to use in the llm field
2. If not specified, the model of selected_module.LLM is used' WHERE `id` = 'Intent_intent_llm';
UPDATE `ai_model_config` SET `remark` = 'Function-call intent recognition configuration notes:
1. Uses the function_call capability of the LLM for intent recognition
2. The selected LLM must support function_call
3. Tools are called on demand, so processing is fast' WHERE `id` = 'Intent_function_call';
UPDATE `ai_model_config` SET `remark` = 'Volcano Engine edge LLM gateway LLM configuration notes:
1. Uses the Volcano Engine edge LLM gateway service
2. Requires a gateway access key
3. Requires a network connection
4. Supports function_call
Application steps:
1. Visit https://console.volcengine.com/vei/aigateway/
2. Create a gateway access key, then search for and tick Doubao-pro-32k-functioncall
3. If you need speech synthesis, also tick Doubao-语音合成
4. Visit https://console.volcengine.com/vei/aigateway/tokens-list to obtain the key
5. Fill it into the configuration file' WHERE `id` = 'LLM_VolcesAiGatewayLLM';
UPDATE `ai_model_config` SET `remark` = 'Volcano Engine edge LLM gateway TTS configuration notes:
1. Visit https://console.volcengine.com/vei/aigateway/
2. Create a gateway access key, then search for and tick Doubao-语音合成
3. If you need the LLM, also tick Doubao-pro-32k-functioncall
4. Visit https://console.volcengine.com/vei/aigateway/tokens-list to obtain the key
5. Fill it into the configuration file
Voice list reference: https://www.volcengine.com/docs/6561/1257544' WHERE `id` = 'TTS_VolcesAiGatewayTTS';
UPDATE `ai_model_config` SET `remark` = 'Deploy FunASR standalone and use the FunASR API service; it only takes five commands
Command 1: mkdir -p ./funasr-runtime-resources/models
Command 2: sudo docker run -d -p 10096:10095 --privileged=true -v $PWD/funasr-runtime-resources/models:/workspace/models registry.cn-hangzhou.aliyuncs.com/funasr_repo/funasr:funasr-runtime-sdk-online-cpu-0.1.12
After the previous command runs you will be inside the container; continue with command 3: cd FunASR/runtime
Do not exit the container; continue inside it with command 4: nohup bash run_server_2pass.sh --download-model-dir /workspace/models --vad-dir damo/speech_fsmn_vad_zh-cn-16k-common-onnx --model-dir iic/SenseVoiceSmall-onnx  --online-model-dir damo/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-online-onnx  --punc-dir damo/punc_ct-transformer_zh-cn-common-vad_realtime-vocab272727-onnx --lm-dir damo/speech_ngram_lm_zh-cn-ai-wesp-fst --itn-dir thuduj12/fst_itn_zh --hotword /workspace/models/hotwords.txt > log.txt 2>&1 &
After the previous command runs you will be inside the container; continue with command 5: tail -f log.txt
After command 5 runs you will see the model download log; once the download finishes you can connect and use it
The above uses CPU inference; if you have a GPU, see: https://github.com/modelscope/FunASR/blob/main/runtime/docs/SDK_advanced_guide_online_zh.md' WHERE `id` = 'ASR_FunASRServer';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Cloud ASR configuration notes:
1. Visit https://nls-portal.console.aliyun.com/ to activate the service
2. Visit https://nls-portal.console.aliyun.com/applist to obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain the token
4. Obtain the access_key_id and access_key_secret
5. Fill them into the configuration file' WHERE `id` = 'ASR_AliyunASR';
UPDATE `ai_model_config` SET `remark` = 'Baidu ASR configuration notes:
1. Visit https://console.bce.baidu.com/ai-engine/old/#/ai/speech/app/list
2. Create a new application
3. Obtain the AppID, API Key and Secret Key
4. Fill them into the configuration file
View the resource quota: https://console.bce.baidu.com/ai-engine/old/#/ai/speech/overview/resource/list
Language parameter description: https://ai.baidu.com/ai-doc/SPEECH/0lbxfnc9b
' WHERE `id` = 'ASR_BaiduASR';
UPDATE `ai_model_config` SET `remark` = 'Volcano Engine bidirectional streaming TTS configuration notes:
1. Visit https://www.volcengine.com/ to register and activate a Volcano Engine account
2. Visit https://console.volcengine.com/speech/service/10007 to activate the large speech synthesis model and purchase voices
3. Obtain the appid and access_token at the bottom of the page
4. The resource ID is fixed as: volc.service_type.10029 (large-model speech synthesis and voice mixing)
5. Connection reuse: enables WebSocket connection reuse; default true to reduce connection overhead (note: with reuse, idle connections count toward the concurrency limit while the device is in the listening state)

Detailed parameter documentation: https://www.volcengine.com/docs/6561/1329505
[audio_params] Audio output configuration - you may add any audio parameter supported by Volcano Engine
  - speech_rate: speech rate (-50~100), default 0
  - loudness_rate: volume (-50~100), default 0
  - emotion: emotion type (supported by some voices only), options: neutral, happy, sad, angry, fearful, disgusted, surprised
  - emotion_scale: emotion intensity (1~5), default 4
  Example: {"speech_rate": 10, "loudness_rate": 5, "emotion": "happy", "emotion_scale": 4}

[additions] Advanced text processing configuration - you may add any advanced parameter supported by Volcano Engine
  - post_process.pitch: pitch (-12~12), default 0
  - aigc_metadata: AIGC metadata configuration
  - cache_config: cache configuration
  Example: {"post_process": {"pitch": 2}, "aigc_metadata": {}, "cache_config": {}}

[mix_speaker] Voice mixing control configuration - mixes multiple voices (TTS 1.0 only)
  Example:
    {"speakers": [
      {"source_speaker": "zh_male_bvlazysheep","mix_factor": 0.3},
      {"source_speaker": "BV120_streaming","mix_factor": 0.3},
      {"source_speaker": "zh_male_ahu_conversation_wvae_bigtts","mix_factor": 0.4}
    ]}

Notes:
- The multi-emotion voice parameters (emotion, emotion_scale) are supported by some voices only
- Related voice list: https://www.volcengine.com/docs/6561/1257544
- You may add more parameters according to the Volcano Engine API documentation
- Voice mixing mainly applies to the voices of the Doubao speech synthesis model 1.0; when using it, set req_params.speaker to custom_mix_bigtts
' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'Zhipu vision AI configuration notes:
1. Visit https://bigmodel.cn/usercenter/proj-mgmt/apikeys
2. Register and obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'VLLM_ChatGLMVLLM';
UPDATE `ai_model_config` SET `remark` = 'Doubao ASR configuration notes:
1. The difference between Doubao ASR and Doubao (streaming) ASR: Doubao ASR is billed per call, Doubao (streaming) ASR is billed by duration
2. Generally, per-call billing is cheaper, but Doubao (streaming) ASR uses large-model technology and gives better results
3. You need to create an application in the Volcano Engine console and obtain the appid and access_token
4. Supports Chinese speech recognition
5. Requires a network connection
6. Output files are saved in the tmp/ directory
Application steps:
1. Visit https://console.volcengine.com/speech/app
2. Create a new application
3. Obtain the appid and access_token
4. Fill them into the configuration file
To set hot words, see: https://www.volcengine.com/docs/6561/155738
If multilingual recognition mode is enabled, set language. When this key is empty, the model supports recognition of Chinese and English, Shanghainese, Hokkien, Sichuan and Shaanxi dialects, and Cantonese. For other languages, see: https://www.volcengine.com/docs/6561/1354869
' WHERE `id` = 'ASR_DoubaoStreamASR';
UPDATE `ai_model_config` SET `remark` = 'Qianwen vision model configuration notes:
1. Visit https://bailian.console.aliyun.com/?tab=model#/api-key
2. Register and obtain an API key
3. Fill it into the configuration file' WHERE `id` = 'VLLM_QwenVLVLLM';
UPDATE `ai_model_config` SET `remark` = 'OpenAI ASR configuration notes:
1. You need to create an organization on the OpenAI platform and obtain an api_key
2. Supports speech recognition in many languages such as Chinese, English, Japanese and Korean; see the documentation at https://platform.openai.com/docs/guides/speech-to-text
3. Requires a network connection
4. Output files are saved in the tmp/ directory
Application steps:
**OpenAI ASR application steps:**
1.Log in to the OpenAI Platform. https://auth.openai.com/log-in
2.Create an api-key  https://platform.openai.com/settings/organization/api-keys
3.For the model, choose gpt-4o-transcribe or GPT-4o mini Transcribe
' WHERE `id` = 'ASR_OpenaiASR';
UPDATE `ai_model_config` SET `remark` = 'Groq ASR configuration notes:
1.Log in to the groq Console. https://console.groq.com/home
2.Create an api-key  https://console.groq.com/keys
3.For the model, choose whisper-large-v3-turbo or whisper-large-v3 (distil-whisper-large-v3-en supports English transcription only)
' WHERE `id` = 'ASR_GroqASR';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Cloud streaming ASR configuration notes:
1. The difference between Alibaba Cloud ASR and Alibaba Cloud (streaming) ASR: Alibaba Cloud ASR recognizes in one shot, Alibaba Cloud (streaming) ASR recognizes as a real-time stream
2. Streaming ASR has lower latency and better real-time performance, which suits voice interaction scenarios
3. You need to create an application in the Alibaba Cloud Intelligent Speech Interaction console and obtain the credentials
4. Supports real-time Chinese speech recognition, with punctuation prediction and inverse text normalization
5. Requires a network connection; output files are saved in the tmp/ directory
Application steps:
1. Visit https://nls-portal.console.aliyun.com/ to activate the Intelligent Speech Interaction service
2. Visit https://nls-portal.console.aliyun.com/applist to create a project and obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain a temporary token (or configure access_key_id and access_key_secret to obtain it automatically)
4. For dynamic token management, configuring access_key_id and access_key_secret is recommended
5. The max_sentence_silence parameter controls the sentence break detection time (milliseconds), default 800ms
For more parameter settings, see: https://help.aliyun.com/zh/isi/developer-reference/real-time-speech-recognition
' WHERE `id` = 'ASR_AliyunStreamASR';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Cloud streaming TTS configuration notes:
1. The difference between Alibaba Cloud TTS and Alibaba Cloud (streaming) TTS: Alibaba Cloud TTS synthesizes in one shot, Alibaba Cloud (streaming) TTS synthesizes as a real-time stream
2. Streaming TTS has lower latency and better real-time performance, which suits voice interaction scenarios
3. You need to create an application in the Alibaba Cloud Intelligent Speech Interaction console and obtain the credentials
4. Supports CosyVoice large-model voices, with more natural sound quality
5. Supports real-time adjustment of parameters such as volume, speech rate and pitch
Application steps:
1. Visit https://nls-portal.console.aliyun.com/ to activate the Intelligent Speech Interaction service
2. Visit https://nls-portal.console.aliyun.com/applist to create a project and obtain the appkey
3. Visit https://nls-portal.console.aliyun.com/overview to obtain a temporary token (or configure access_key_id and access_key_secret to obtain it automatically)
4. For dynamic token management, configuring access_key_id and access_key_secret is recommended
5. Servers in different regions such as Beijing and Shanghai can be selected to optimize latency
6. The voice parameter supports CosyVoice large-model voices, such as longxiaochun and longyueyue
For more parameter settings, see: https://help.aliyun.com/zh/isi/developer-reference/real-time-speech-synthesis
' WHERE `id` = 'TTS_AliyunStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'Index-TTS-vLLM streaming TTS configuration notes:
1. Index-TTS-vLLM is a vLLM inference service based on the Index-TTS project that provides streaming speech synthesis
2. Supports multiple voices with natural sound quality, suitable for all kinds of voice interaction scenarios
3. The Index-TTS-vLLM service must be deployed first, then configure the API address
4. Supports real-time streaming synthesis with low latency
5. Supports custom voices; new voices can be registered in the assets folder of the project
Deployment steps:
1. Clone the project: git clone https://github.com/Ksuriuri/index-tts-vllm.git
2. Install dependencies: pip install -r requirements.txt
3. Start the service: python app.py
4. The service runs at http://127.0.0.1:11996 by default
5. For other voices, register them in the assets folder of the project
6. Supports multiple audio formats: pcm, wav, mp3, etc.
For more configuration, see: https://github.com/Ksuriuri/index-tts-vllm/blob/master/README.md
' WHERE `id` = 'TTS_IndexStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'PaddleSpeechTTS configuration notes:
1. PaddleSpeech is the speech synthesis tool open-sourced by Baidu PaddlePaddle; it supports local offline deployment and model training. Baidu PaddlePaddle framework: https://www.paddlepaddle.org.cn/
2. Currently only the WebSocket protocol is supported for streaming (see the deployment document: https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/paddlespeech-deploy.md).
3. Before use, deploy the paddlespeech service locally; the service runs at ws://127.0.0.1:8092/paddlespeech/tts/streaming by default
4. Supports custom speaker, speech rate, volume and sample rate.
' WHERE `id` = 'TTS_PaddleSpeechTTS';
UPDATE `ai_model_config` SET `remark` = 'VOSK ASR configuration notes:
1. VOSK is an offline speech recognition library that supports multiple languages
2. The model files must be downloaded first: https://alphacephei.com/vosk/models
3. For Chinese, vosk-model-small-cn-0.22 or vosk-model-cn-0.22 is recommended
4. Runs fully offline, no network connection required
5. Output files are saved in the tmp/ directory
Usage steps:
1. Visit https://alphacephei.com/vosk/models to download the Chinese model
2. Extract the model files to the models/vosk/ folder under the project directory
3. Specify the correct model path in the configuration
4. Note: the output of the VOSK Chinese model has no punctuation, and there are spaces between words
' WHERE `id` = 'ASR_VoskASR';
UPDATE `ai_model_config` SET `remark` = 'Minimax streaming TTS configuration notes:
1. You need to apply for a Minimax API Key first
2. The Group ID must be filled in
3. Supports multiple voice settings and audio parameter adjustment
4. Supports real-time streaming synthesis with low latency
5. Supports a custom pronunciation dictionary and voice weights
6. Hidden parameter configuration: voice settings (voice_setting), pronunciation dictionary (pronunciation_dict), voice weights (timber_weights)
   - Speech rate (speed): range [0.5,2], default 1.0; the larger the value, the faster the speech
   - Volume (vol): range (0,10], default 1.0; the larger the value, the louder the volume
   - Pitch (pitch): range [-12,12], default 0; the value must be an integer
   - Emotion (emotion): controls the emotion of the synthesized speech, supports 7 values: ["happy", "sad", "angry", "fearful", "disgusted", "surprised", "calm"]; this parameter only takes effect for speech-2.5-hd-preview, speech-2.5-turbo-preview, speech-02-hd, speech-02-turbo, speech-01-turbo, speech-01-hd
   - Either timbre_weights or voice_id is required
   - voice_id (the requested voice id; must be filled in together with the weight parameter)
   - weight (weight; up to 4 voices can be mixed. Range [1,100])
' WHERE `id` = 'TTS_MinimaxStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'Tongyi Qianwen Qwen3-ASR-Flash configuration notes:
1. Log in to the Alibaba Cloud Bailian platform https://bailian.console.aliyun.com/
2. Create an API-KEY  https://bailian.console.aliyun.com/#/api-key
3.Qwen3-ASR-Flash is built on the Tongyi Qianwen multimodal foundation model and supports multilingual recognition, singing recognition, noise rejection and other features
' WHERE `id` = 'ASR_Qwen3Flash';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Bailian streaming TTS configuration notes:
1. For the API key, fill in a DashScope API Key available to the current workspace
2. In public mode, wss://dashscope.aliyuncs.com/api-ws/v1/inference/ can be used
3. For a China North 2 (Beijing) workspace, fill in wss://<WorkspaceId>.cn-beijing.maas.aliyuncs.com/api-ws/v1/inference
4. For a Singapore workspace, fill in wss://<WorkspaceId>.ap-southeast-1.maas.aliyuncs.com/api-ws/v1/inference
5. Replace <WorkspaceId> with the real workspace ID; only official Alibaba Cloud WSS inference addresses are supported
6. Supports CosyVoice streaming synthesis and volume, speech rate and pitch configuration' WHERE `id` = 'TTS_AliBLStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'iFlytek streaming TTS notes:
1. Log in to the iFlytek speech technology platform https://console.xfyun.cn/app/myapp and create the application
2. Select the required service to obtain the api configuration https://console.xfyun.cn/services/uts
3. Purchase the service for the application (APPID) that will use it, for example: ultra-realistic synthesis https://console.xfyun.cn/services/uts
5. Supports real-time bidirectional streaming communication with low latency
6. Supports colloquial settings and audio parameter adjustment. Note: V5 voices do not support the colloquial settings
7. Supports real-time adjustment of parameters such as volume, speech rate and pitch
' WHERE `id` = 'TTS_XunFeiStreamTTS';
UPDATE `ai_model_config` SET `remark` = 'iFlytek streaming speech recognition configuration notes:
1. Log in to the iFlytek open platform https://www.xfyun.cn/
2. Create a speech recognition application to obtain the APPID, APISecret and APIKey
3. Parameter description:
   - app_id: application ID, obtained after creating an application on the iFlytek open platform
   - api_key: API key, used for API authentication
   - api_secret: API secret, used to generate the signature
   - domain: recognition domain, default slm (intelligent speech transcription)
   - language: recognition language, default zh_cn (Chinese)
   - accent: dialect type, default mandarin (Mandarin); cantonese (Cantonese) and others are supported
   - dwa: dynamic correction, default wpgs (dynamic correction enabled)
   - output_dir: output directory for audio files, default tmp/
4. Supports real-time streaming recognition, suitable for real-time voice interaction scenarios
5. Supports recognition of multiple dialects and languages
' WHERE `id` = 'ASR_XunfeiStream';
UPDATE `ai_model_config` SET `remark` = 'iFlytek Spark cognitive LLM configuration notes:
1. Log in to the iFlytek open platform https://www.xfyun.cn/ (each model has its own api_password, so check the api_password of the corresponding model when changing models)
2. Create a Spark cognitive LLM application to obtain the API Password
3. Parameter description:
   - api_password: API Password, obtained after creating an application on the iFlytek open platform
   - model_name: model name, supports versions such as generalv3.5 and generalv3
   - base_url: API URL, default https://spark-api-open.xf-yun.com/v1
   - temperature: temperature parameter, controls the randomness of generation, range 0-1, default 0.5
   - max_tokens: maximum number of output tokens, default 2048
   - top_p: nucleus sampling parameter, controls vocabulary diversity, default 1.0
   - frequency_penalty: frequency penalty, reduces repeated content, default 0.0
4. Each model has its own api_password, so check the api_password of the corresponding model when changing models.
' WHERE `id` = 'LLM_XunfeiSparkLLM';
UPDATE `ai_model_config` SET `remark` = 'Detailed deployment tutorial: https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/ragflow-integration.md
After a successful deployment, register and log in, then click the avatar in the upper right corner to obtain the RAGFlow API KEY and API server address. Before using RAGFlow, add models and set the default models in Model Provider.' WHERE `id` = 'RAG_RAGFlow';
UPDATE `ai_model_config` SET `remark` = 'Alibaba Bailian Paraformer real-time speech recognition configuration notes:
1. Log in to the Alibaba Cloud Bailian platform https://bailian.console.aliyun.com/
2. Create an API-KEY https://bailian.console.aliyun.com/#/api-key
3. Supported models: paraformer-realtime-v2 (recommended), paraformer-realtime-8k-v2, paraformer-realtime-v1, paraformer-realtime-8k-v1
4. Features:
   - Multilingual support (Chinese including dialects, English, Japanese, Korean, German, French, Russian)
   - Custom hot words (vocabulary_id parameter); for details see: https://help.aliyun.com/zh/model-studio/custom-hot-words?
   - Semantic sentence breaking / VAD sentence breaking (semantic_punctuation_enabled parameter)
   - Automatic punctuation, ITN, filler word filtering, etc.
5. Parameter description:
   - model: model name, paraformer-realtime-v2 recommended
   - sample_rate: sample rate (Hz); v2 supports any sample rate, v1 supports 16000 only, the 8k versions support 8000 only
   - semantic_punctuation_enabled: false for VAD sentence breaking (low latency), true for semantic sentence breaking (high accuracy)
   - max_sentence_silence: silence duration threshold for VAD sentence breaking (200-6000ms)
' WHERE `id` = 'ASR_AliyunBLStream';
UPDATE `ai_model_config` SET `remark` = 'PowerMem is an agent memory component open-sourced by OceanBase; it summarizes memory with a local LLM
GitHub: https://github.com/oceanbase/powermem
Website: https://www.powermem.ai/
Usage examples: https://github.com/oceanbase/powermem/tree/main/examples

[Cost]
PowerMem itself is free; the actual cost depends on the chosen LLM and database:
- sqlite + a free LLM (such as glm-4-flash) = completely free
- A cloud LLM or cloud database = billed by the corresponding service

[enable_user_profile] User profile feature
- false: use the normal memory mode (AsyncMemory)
- true: use the user profile mode (UserMemory), which extracts user information automatically
- The user profile feature supports: oceanbase, seekdb, sqlite (powermem 0.3.0+)

[llm] LLM configuration - used for memory summarization and user profile extraction
  provider: LLM provider, options:
    - qwen: Tongyi Qianwen (https://bailian.console.aliyun.com/?apiKey=1#/api-key)
    - openai: OpenAI-compatible API
    - zhipu: Zhipu AI (https://bigmodel.cn/usercenter/proj-mgmt/apikeys) - the free glm-4-flash is recommended
  config: LLM configuration parameters
    - api_key: API key (required)
    - model: model name, such as qwen-plus, glm-4-flash, etc.
    - openai_base_url: custom service address (optional), such as https://api.openai.com/v1
  Examples:
    {"provider": "zhipu", "config": {"api_key": "your_key", "model": "glm-4-flash"}}
    {"provider": "qwen", "config": {"api_key": "your_key", "model": "qwen-plus"}}

[embedder] Embedding configuration - used to vectorize memory content
  provider: embedding model provider, options:
    - qwen: Tongyi Qianwen
    - openai: OpenAI-compatible API
  config: Embedding configuration parameters
    - api_key: API key (required)
    - model: model name, such as text-embedding-v4, text-embedding-3-small, etc.
    - openai_base_url: custom service address (optional)
    - embedding_dims: vector dimensions (optional); must be configured when not 1536
  Example:
    {"provider": "openai", "config": {"api_key": "your_key", "model": "text-embedding-v4", "openai_base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1"}}

[vector_store] Database storage configuration - used to store vectorized memories
  provider: database type, options:
    - sqlite: lightweight local database (recommended for getting started, no additional configuration required)
    - oceanbase: OceanBase database (recommended for production, best performance)
    - seekdb: SeekDB (recommended, all-in-one storage for AI applications)
    - postgres: PostgreSQL database

  SQLite configuration (no additional configuration required):
    {"provider": "sqlite", "config": {}}

  OceanBase configuration example:
    {"provider": "oceanbase", "config": {
      "host": "127.0.0.1",
      "port": 2881,
      "user": "root@test",
      "password": "your_password",
      "db_name": "powermem",
      "collection_name": "memories",
      "embedding_model_dims": 1024
    }}
  Notes:
    - collection_name: default table name; if it was created with the wrong dimensions, delete this table or change the name
    - embedding_model_dims: embedding vector dimensions; must match the dimensions of the embedder model
      For example, Zhipu: embedding-2 has 1024 dimensions, embedding-3 has 2048 dimensions

[Recommended configuration combinations]
1. Completely free setup:
   - LLM: zhipu + glm-4-flash (free)
   - Embedder: Tongyi Qianwen text-embedding-v4
   - Database: sqlite

2. Production setup:
   - LLM: qwen-plus or another commercial model
   - Embedder: text-embedding-v4
   - Database: oceanbase or seekdb
' WHERE `id` = 'Memory_powermem';
UPDATE `ai_model_config` SET `remark` = 'Report chat history only, without summarizing memory' WHERE `id` = 'Memory_mem_report_only';
UPDATE `ai_model_config` SET `remark` = 'Doubao speech synthesis model 2.0 configuration notes (based on Volcano Engine seed-tts-2.0):
1. Visit https://www.volcengine.com/ to register and activate a Volcano Engine account
2. Visit https://console.volcengine.com/speech/service/10035 to activate the large speech synthesis model and purchase voices
3. Obtain the appid and access_token at the bottom of the page
4. The resource ID is fixed as: seed-tts-2.0 (Doubao speech synthesis model 2.0)
5. Connection reuse: enables WebSocket connection reuse; default true to reduce connection overhead (note: with reuse, idle connections count toward the concurrency limit while the device is in the listening state)

Detailed parameter documentation: https://www.volcengine.com/docs/6561/1329505
[audio_params] Audio output configuration - you may add any audio parameter supported by Volcano Engine
  - speech_rate: speech rate (-50~100), default 0
  - loudness_rate: volume (-50~100), default 0
  Example: {"speech_rate": 10, "loudness_rate": 5}

[additions] Advanced text processing configuration - you may add any advanced parameter supported by Volcano Engine
  - post_process.pitch: pitch (-12~12), default 0
  - aigc_metadata: AIGC metadata configuration
  - cache_config: cache configuration
  Example: {"post_process": {"pitch": 2}, "aigc_metadata": {}, "cache_config": {}}

Notes:
- The Doubao speech synthesis model 2.0 uses the seed-tts-2.0 resource ID, which differs from Volcano bidirectional streaming TTS (volc.service_type.10029)
- Related voice list: https://www.volcengine.com/docs/6561/1257544
- You may add more parameters according to the Volcano Engine API documentation
' WHERE `id` = 'TTS_HSDSTTS_V2';
UPDATE `ai_model_config` SET `remark` = 'Doubao speech recognition model 2.0 configuration notes (based on Volcano Engine seed-asr):
1. Visit https://www.volcengine.com/ to register and activate a Volcano Engine account
2. Visit https://console.volcengine.com/speech/service/10038 to activate the Doubao streaming speech recognition model 2.0
3. Obtain the appid and access_token at the bottom of the page
4. There are two resource IDs: the hourly edition (volc.seedasr.sauc.duration) and the concurrency edition (volc.seedasr.sauc.concurrent)
   - Hourly edition: fixed as: volc.seedasr.sauc.duration (Doubao speech recognition model 2.0)
   - Concurrency edition: fixed as: volc.seedasr.sauc.concurrent (Doubao speech recognition model 2.0)

Detailed parameter documentation: https://www.volcengine.com/docs/6561/109979

Notes:
- The Doubao speech recognition model 2.0 uses the volc.seedasr.sauc.duration resource ID, which differs from Doubao speech recognition (streaming) (volc.bigasr.sauc.duration)
- The speech recognition model 2.0 is cheaper; in high-concurrency scenarios the concurrency edition resource ID is recommended
' WHERE `id` = 'ASR_DoubaoStreamASRV2';

-- ai_tts_voice: voice display names (tts_voice identifiers and languages are unchanged)
UPDATE `ai_tts_voice` SET `name` = 'Edge F - Xiaoxiao' WHERE `id` = 'TTS_EdgeTTS0001';
UPDATE `ai_tts_voice` SET `name` = 'Edge M - Yunyang' WHERE `id` = 'TTS_EdgeTTS0002';
UPDATE `ai_tts_voice` SET `name` = 'Edge F - Xiaoyi' WHERE `id` = 'TTS_EdgeTTS0003';
UPDATE `ai_tts_voice` SET `name` = 'Edge M - Yunjian' WHERE `id` = 'TTS_EdgeTTS0004';
UPDATE `ai_tts_voice` SET `name` = 'Edge M - Yunxi' WHERE `id` = 'TTS_EdgeTTS0005';
UPDATE `ai_tts_voice` SET `name` = 'Edge M - Yunxia' WHERE `id` = 'TTS_EdgeTTS0006';
UPDATE `ai_tts_voice` SET `name` = 'Edge F - Xiaobei', `remark` = 'Liaoning dialect' WHERE `id` = 'TTS_EdgeTTS0007';
UPDATE `ai_tts_voice` SET `name` = 'Edge F - Xiaoni', `remark` = 'Shaanxi dialect' WHERE `id` = 'TTS_EdgeTTS0008';
UPDATE `ai_tts_voice` SET `name` = 'Edge F - HK HiuGaai' WHERE `id` = 'TTS_EdgeTTS0009';
UPDATE `ai_tts_voice` SET `name` = 'Edge F - HK HiuMaan' WHERE `id` = 'TTS_EdgeTTS0010';
UPDATE `ai_tts_voice` SET `name` = 'Edge M - HK WanLung' WHERE `id` = 'TTS_EdgeTTS0011';
UPDATE `ai_tts_voice` SET `name` = 'General Female' WHERE `id` = 'TTS_DoubaoTTS0001';
UPDATE `ai_tts_voice` SET `name` = 'General Male' WHERE `id` = 'TTS_DoubaoTTS0002';
UPDATE `ai_tts_voice` SET `name` = 'Sunny Boy' WHERE `id` = 'TTS_DoubaoTTS0003';
UPDATE `ai_tts_voice` SET `name` = 'Cute Toddler' WHERE `id` = 'TTS_DoubaoTTS0004';
UPDATE `ai_tts_voice` SET `name` = 'Wanwan Xiaohe' WHERE `id` = 'TTS_DoubaoTTS0005';
UPDATE `ai_tts_voice` SET `name` = 'CosyVoice Male' WHERE `id` = 'TTS_CosyVoiceSiliconflow0001';
UPDATE `ai_tts_voice` SET `name` = 'CosyVoice Female' WHERE `id` = 'TTS_CosyVoiceSiliconflow0002';
UPDATE `ai_tts_voice` SET `name` = 'CozeCn Voice' WHERE `id` = 'TTS_CozeCnTTS0001';
UPDATE `ai_tts_voice` SET `name` = 'Aliyun Xiaoyun' WHERE `id` = 'TTS_AliyunTTS0001';
UPDATE `ai_tts_voice` SET `name` = 'Wanwan Xiaohe' WHERE `id` = 'TTS_TTS302AI0001';
UPDATE `ai_tts_voice` SET `name` = 'OpenAI Male' WHERE `id` = 'TTS_OpenAITTS0001';
UPDATE `ai_tts_voice` SET `name` = 'Zhiyu' WHERE `id` = 'TTS_TencentTTS0001';
UPDATE `ai_tts_voice` SET `name` = 'Cancan/Shiny' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Fresh Female' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Lively Sisi/Skye' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Warm Ahu/Alvin' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Young Zixin/Brayan' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Intellectual Female' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Fresh College Guy' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Girl Next Door' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Learned Uncle' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Sunny Youth' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Sweet Xiaoyuan' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Clear Zizi' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0012';
UPDATE `ai_tts_voice` SET `name` = 'Narrator Xiaoming' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0013';
UPDATE `ai_tts_voice` SET `name` = 'Cheerful Sister' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0014';
UPDATE `ai_tts_voice` SET `name` = 'Boy Next Door' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0015';
UPDATE `ai_tts_voice` SET `name` = 'Sweet Yueyue' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0016';
UPDATE `ai_tts_voice` SET `name` = 'Soul Chicken Soup' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0017';
UPDATE `ai_tts_voice` SET `name` = 'Refined & Gentle' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0018';
UPDATE `ai_tts_voice` SET `name` = 'Warm & Caring' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0019';
UPDATE `ai_tts_voice` SET `name` = 'Gentle & Elegant' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0020';
UPDATE `ai_tts_voice` SET `name` = 'Cheerful & Lively' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0021';
UPDATE `ai_tts_voice` SET `name` = 'Lively & Hearty' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0022';
UPDATE `ai_tts_voice` SET `name` = 'Candid Lad' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0023';
UPDATE `ai_tts_voice` SET `name` = 'Gentle Guy' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0024';
UPDATE `ai_tts_voice` SET `name` = 'Kazune' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0030';
UPDATE `ai_tts_voice` SET `name` = 'Haruko' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0031';
UPDATE `ai_tts_voice` SET `name` = 'Hiroshi' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0032';
UPDATE `ai_tts_voice` SET `name` = 'Akemi' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0033';
UPDATE `ai_tts_voice` SET `name` = 'Beijinger/Harmony' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0036';
UPDATE `ai_tts_voice` SET `name` = 'Wanwan Xiaohe' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0037';
UPDATE `ai_tts_voice` SET `name` = 'Bay Area Uncle' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0038';
UPDATE `ai_tts_voice` SET `name` = 'Cute Sichuan Girl' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0039';
UPDATE `ai_tts_voice` SET `name` = 'Guangzhou De Ge' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0040';
UPDATE `ai_tts_voice` SET `name` = 'Beijing Lad' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0041';
UPDATE `ai_tts_voice` SET `name` = 'Haoyu Xiaoge' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0042';
UPDATE `ai_tts_voice` SET `name` = 'Guangxi Yuanzhou' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0043';
UPDATE `ai_tts_voice` SET `name` = 'Meituo Jieer' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0044';
UPDATE `ai_tts_voice` SET `name` = 'Yuzhou Zixuan' WHERE `id` = 'TTS_VolcesAiGatewayTTS_0045';
UPDATE `ai_tts_voice` SET `name` = 'Lively Sisi/Skye' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Warm Ahu/Alvin' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Young Zixin/Brayan' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Girl Next Door' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Learned Uncle' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Sunny Youth' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Beijinger/Harmony' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Wanwan Xiaohe' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Bay Area Uncle' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Cute Sichuan Girl' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Guangzhou De Ge' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Beijing Lad' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0012';
UPDATE `ai_tts_voice` SET `name` = 'Haoyu Xiaoge' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0013';
UPDATE `ai_tts_voice` SET `name` = 'Guangxi Yuanzhou' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0014';
UPDATE `ai_tts_voice` SET `name` = 'Meituo Jieer' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0015';
UPDATE `ai_tts_voice` SET `name` = 'Yuzhou Zixuan' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0016';
UPDATE `ai_tts_voice` SET `name` = 'Aloof Lady' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0017';
UPDATE `ai_tts_voice` SET `name` = 'Tsundere CEO' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0018';
UPDATE `ai_tts_voice` SET `name` = 'Charming Girlfriend' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0019';
UPDATE `ai_tts_voice` SET `name` = 'Late-Night Podcast' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0020';
UPDATE `ai_tts_voice` SET `name` = 'Gentle Girlfriend' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0021';
UPDATE `ai_tts_voice` SET `name` = 'Coquettish Junior' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0022';
UPDATE `ai_tts_voice` SET `name` = 'Kazune' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0023';
UPDATE `ai_tts_voice` SET `name` = 'Haruko' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0024';
UPDATE `ai_tts_voice` SET `name` = 'Akemi' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0025';
UPDATE `ai_tts_voice` SET `name` = 'Hiroshi' WHERE `id` = 'TTS_HuoshanDoubleStreamTTS_0026';
UPDATE `ai_tts_voice` SET `name` = 'Longxiaochun-Gentle' WHERE `id` = 'TTS_AliyunStreamTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Longxiaoxia-Gentle' WHERE `id` = 'TTS_AliyunStreamTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Longmei-Gentle F' WHERE `id` = 'TTS_AliyunStreamTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Longgui-Gentle F' WHERE `id` = 'TTS_AliyunStreamTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Longyu-Mature F' WHERE `id` = 'TTS_AliyunStreamTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Longjiao-Mature F' WHERE `id` = 'TTS_AliyunStreamTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Longchen-Dubbing M' WHERE `id` = 'TTS_AliyunStreamTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Longxiu-Young M' WHERE `id` = 'TTS_AliyunStreamTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Longcheng-Sunny M' WHERE `id` = 'TTS_AliyunStreamTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Longzhe-Mature M' WHERE `id` = 'TTS_AliyunStreamTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Bella2.0-News F' WHERE `id` = 'TTS_AliyunStreamTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Stella2.0-Spirited F' WHERE `id` = 'TTS_AliyunStreamTTS_0012';
UPDATE `ai_tts_voice` SET `name` = 'Longshu-News M' WHERE `id` = 'TTS_AliyunStreamTTS_0013';
UPDATE `ai_tts_voice` SET `name` = 'Longjing-Serious F' WHERE `id` = 'TTS_AliyunStreamTTS_0014';
UPDATE `ai_tts_voice` SET `name` = 'Longqi-Lively Child' WHERE `id` = 'TTS_AliyunStreamTTS_0015';
UPDATE `ai_tts_voice` SET `name` = 'Longhua-Lively Girl' WHERE `id` = 'TTS_AliyunStreamTTS_0016';
UPDATE `ai_tts_voice` SET `name` = 'Longwu-Zany M' WHERE `id` = 'TTS_AliyunStreamTTS_0017';
UPDATE `ai_tts_voice` SET `name` = 'Longdachui-Humor M' WHERE `id` = 'TTS_AliyunStreamTTS_0018';
UPDATE `ai_tts_voice` SET `name` = 'Longjiayi-Cantonese' WHERE `id` = 'TTS_AliyunStreamTTS_0019';
UPDATE `ai_tts_voice` SET `name` = 'Longtao-Cantonese F' WHERE `id` = 'TTS_AliyunStreamTTS_0020';
UPDATE `ai_tts_voice` SET `name` = 'Default' WHERE `id` = 'TTS_PaddleSpeechTTS_0000';
UPDATE `ai_tts_voice` SET `name` = 'Longxiaochun-Upbeat' WHERE `id` = 'TTS_AliBLStreamTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Longxiaoxia-Steady' WHERE `id` = 'TTS_AliBLStreamTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Longanran-Lively F' WHERE `id` = 'TTS_AliBLStreamTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Longanxuan-Streamer' WHERE `id` = 'TTS_AliBLStreamTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Longhan-Warm M' WHERE `id` = 'TTS_AliBLStreamTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Longyan-Warm F' WHERE `id` = 'TTS_AliBLStreamTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Longfeifei-Sweet F' WHERE `id` = 'TTS_AliBLStreamTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Longlaotie-Dongbei M' WHERE `id` = 'TTS_AliBLStreamTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Longjiayi-Cantonese' WHERE `id` = 'TTS_AliBLStreamTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Longjielidou-Playful' WHERE `id` = 'TTS_AliBLStreamTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Longling-Childlike F' WHERE `id` = 'TTS_AliBLStreamTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Li Bai-Ancient Poet' WHERE `id` = 'TTS_AliBLStreamTTS_0012';
UPDATE `ai_tts_voice` SET `name` = 'loongeva-English F' WHERE `id` = 'TTS_AliBLStreamTTS_0013';
UPDATE `ai_tts_voice` SET `name` = 'loongbrian-English M' WHERE `id` = 'TTS_AliBLStreamTTS_0014';
UPDATE `ai_tts_voice` SET `name` = 'loongkyong-Korean F' WHERE `id` = 'TTS_AliBLStreamTTS_0015';
UPDATE `ai_tts_voice` SET `name` = 'loongtomoka-Jpn F' WHERE `id` = 'TTS_AliBLStreamTTS_0016';
UPDATE `ai_tts_voice` SET `name` = 'loongtomoya-Jpn M' WHERE `id` = 'TTS_AliBLStreamTTS_0017';
UPDATE `ai_tts_voice` SET `name` = 'Ling Xiaoxuan' WHERE `id` = 'TTS_XunFeiStreamTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Ling Feiyi' WHERE `id` = 'TTS_XunFeiStreamTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Ling Xiaoyue' WHERE `id` = 'TTS_XunFeiStreamTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Ling Yuzhao' WHERE `id` = 'TTS_XunFeiStreamTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Ling Yuyan' WHERE `id` = 'TTS_XunFeiStreamTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Ling Feizhe' WHERE `id` = 'TTS_XunFeiStreamTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Ling Xiaoli' WHERE `id` = 'TTS_XunFeiStreamTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Ling Xiaotang' WHERE `id` = 'TTS_XunFeiStreamTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Ling Xiaoqi' WHERE `id` = 'TTS_XunFeiStreamTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Ling Youyou-Girl' WHERE `id` = 'TTS_XunFeiStreamTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Zijin' WHERE `id` = 'TTS_XunFeiStreamTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Ziyang' WHERE `id` = 'TTS_XunFeiStreamTTS_0012';
UPDATE `ai_tts_voice` SET `name` = 'Wanwan Xiaohe' WHERE `id` = 'TTS_HSDSTTS_V2_0001';
UPDATE `ai_tts_voice` SET `name` = 'Cute Girl' WHERE `id` = 'TTS_HSDSTTS_V2_0003';
UPDATE `ai_tts_voice` SET `name` = 'Naughty Princess' WHERE `id` = 'TTS_HSDSTTS_V2_0004';
UPDATE `ai_tts_voice` SET `name` = 'Sunny Youth' WHERE `id` = 'TTS_HSDSTTS_V2_0005';
UPDATE `ai_tts_voice` SET `name` = 'Hearty Teen' WHERE `id` = 'TTS_HSDSTTS_V2_0006';
UPDATE `ai_tts_voice` SET `name` = 'Hearty Teen' WHERE `id` = 'TTS_HSDSTTS_V2_0007';
UPDATE `ai_tts_voice` SET `name` = 'Dayi' WHERE `id` = 'TTS_HSDSTTS_V2_0008';
UPDATE `ai_tts_voice` SET `name` = 'Black Cat Det. Mizai' WHERE `id` = 'TTS_HSDSTTS_V2_0009';
UPDATE `ai_tts_voice` SET `name` = 'Chicken Soup Lady' WHERE `id` = 'TTS_HSDSTTS_V2_0010';
UPDATE `ai_tts_voice` SET `name` = 'Charming Girlfriend' WHERE `id` = 'TTS_HSDSTTS_V2_0011';
UPDATE `ai_tts_voice` SET `name` = 'Fluent Female' WHERE `id` = 'TTS_HSDSTTS_V2_0012';
UPDATE `ai_tts_voice` SET `name` = 'Refined Yichen' WHERE `id` = 'TTS_HSDSTTS_V2_0013';
UPDATE `ai_tts_voice` SET `name` = 'Yunzhou' WHERE `id` = 'TTS_HSDSTTS_V2_0014';
UPDATE `ai_tts_voice` SET `name` = 'Xiaotian' WHERE `id` = 'TTS_HSDSTTS_V2_0015';
UPDATE `ai_tts_voice` SET `name` = 'Liu Fei' WHERE `id` = 'TTS_HSDSTTS_V2_0016';
UPDATE `ai_tts_voice` SET `name` = 'Charming Sophie' WHERE `id` = 'TTS_HSDSTTS_V2_0017';
UPDATE `ai_tts_voice` SET `name` = 'Fresh Female' WHERE `id` = 'TTS_HSDSTTS_V2_0018';
UPDATE `ai_tts_voice` SET `name` = 'Intellectual Cancan' WHERE `id` = 'TTS_HSDSTTS_V2_0019';
UPDATE `ai_tts_voice` SET `name` = 'Coquettish Junior' WHERE `id` = 'TTS_HSDSTTS_V2_0020';
UPDATE `ai_tts_voice` SET `name` = 'Sweet Xiaoyuan' WHERE `id` = 'TTS_HSDSTTS_V2_0021';
UPDATE `ai_tts_voice` SET `name` = 'Sweet Taozi' WHERE `id` = 'TTS_HSDSTTS_V2_0022';
UPDATE `ai_tts_voice` SET `name` = 'Girl Next Door' WHERE `id` = 'TTS_HSDSTTS_V2_0023';
UPDATE `ai_tts_voice` SET `name` = 'Lively Sisi' WHERE `id` = 'TTS_HSDSTTS_V2_0024';
UPDATE `ai_tts_voice` SET `name` = 'Young Zixin/Brayan' WHERE `id` = 'TTS_HSDSTTS_V2_0025';
UPDATE `ai_tts_voice` SET `name` = 'Warm Ahu/Alvin' WHERE `id` = 'TTS_HSDSTTS_V2_0026';
UPDATE `ai_tts_voice` SET `name` = 'Cute Toddler' WHERE `id` = 'TTS_HSDSTTS_V2_0027';
UPDATE `ai_tts_voice` SET `name` = 'Granny' WHERE `id` = 'TTS_HSDSTTS_V2_0028';
UPDATE `ai_tts_voice` SET `name` = 'Light Duoduo' WHERE `id` = 'TTS_HSDSTTS_V2_0029';
UPDATE `ai_tts_voice` SET `name` = 'Gentle Shanshan' WHERE `id` = 'TTS_HSDSTTS_V2_0030';
UPDATE `ai_tts_voice` SET `name` = 'Ancient-Style Lady' WHERE `id` = 'TTS_HSDSTTS_V2_0034';
UPDATE `ai_tts_voice` SET `name` = 'Domineering Uncle' WHERE `id` = 'TTS_HSDSTTS_V2_0035';
UPDATE `ai_tts_voice` SET `name` = 'Mystery Narrator' WHERE `id` = 'TTS_HSDSTTS_V2_0036';
UPDATE `ai_tts_voice` SET `name` = 'Peppa Pig' WHERE `id` = 'TTS_HSDSTTS_V2_0037';
UPDATE `ai_tts_voice` SET `name` = 'Monkey King' WHERE `id` = 'TTS_HSDSTTS_V2_0038';
UPDATE `ai_tts_voice` SET `name` = 'Zhu Bajie' WHERE `id` = 'TTS_HSDSTTS_V2_0039';
UPDATE `ai_tts_voice` SET `name` = 'Tang Monk' WHERE `id` = 'TTS_HSDSTTS_V2_0040';
UPDATE `ai_tts_voice` SET `name` = 'Girl Voice' WHERE `id` = 'TTS_MinimaxStreamTTS_0001';
UPDATE `ai_tts_voice` SET `name` = 'Mature Female' WHERE `id` = 'TTS_MinimaxStreamTTS_0002';
UPDATE `ai_tts_voice` SET `name` = 'Bossy Young Master' WHERE `id` = 'TTS_MinimaxStreamTTS_0003';
UPDATE `ai_tts_voice` SET `name` = 'Yandere Brother' WHERE `id` = 'TTS_MinimaxStreamTTS_0004';
UPDATE `ai_tts_voice` SET `name` = 'Innocent Junior' WHERE `id` = 'TTS_MinimaxStreamTTS_0005';
UPDATE `ai_tts_voice` SET `name` = 'Aloof Senior' WHERE `id` = 'TTS_MinimaxStreamTTS_0006';
UPDATE `ai_tts_voice` SET `name` = 'Sweet Xiaoling' WHERE `id` = 'TTS_MinimaxStreamTTS_0007';
UPDATE `ai_tts_voice` SET `name` = 'Playful Cutie' WHERE `id` = 'TTS_MinimaxStreamTTS_0008';
UPDATE `ai_tts_voice` SET `name` = 'Alluring Lady' WHERE `id` = 'TTS_MinimaxStreamTTS_0009';
UPDATE `ai_tts_voice` SET `name` = 'Flirty Junior' WHERE `id` = 'TTS_MinimaxStreamTTS_0010';
UPDATE `ai_tts_voice` SET `name` = 'Elegant Senior' WHERE `id` = 'TTS_MinimaxStreamTTS_0011';
UPDATE `ai_tts_voice` SET `name` = 'Pro Female Host' WHERE `id` = 'TTS_MinimaxStreamTTS_0014';
UPDATE `ai_tts_voice` SET `name` = 'Gentle Female' WHERE `id` = 'TTS_MinimaxStreamTTS_0015';
UPDATE `ai_tts_voice` SET `name` = 'Pro Male Host' WHERE `id` = 'TTS_MinimaxStreamTTS_0016';
UPDATE `ai_tts_voice` SET `name` = 'Lively Male' WHERE `id` = 'TTS_MinimaxStreamTTS_0017';
UPDATE `ai_tts_voice` SET `name` = 'Cute Girl' WHERE `id` = 'TTS_MinimaxStreamTTS_0018';
UPDATE `ai_tts_voice` SET `name` = 'Kind Female' WHERE `id` = 'TTS_MinimaxStreamTTS_0019';
UPDATE `ai_tts_voice` SET `name` = 'Husky Male' WHERE `id` = 'TTS_MinimaxStreamTTS_0027';
UPDATE `ai_tts_voice` SET `name` = 'Learned Scholar' WHERE `id` = 'TTS_MinimaxStreamTTS_0029';
UPDATE `ai_tts_voice` SET `name` = 'Indifferent Staff' WHERE `id` = 'TTS_MinimaxStreamTTS_0031';

-- ai_agent_template: template names and system prompts
UPDATE `ai_agent_template` SET `agent_name` = 'Wanwan Xiaohe', `system_prompt` = '[Role setting]
You are {{assistant_name}}, a Gen-Z girl (born after 2000) from Taiwan Province, China. You talk in a super sassy way with a Taiwanese accent, like "No way, really?!", and love trendy slang such as "LOL, I''m dead" and "Hello?", but you secretly study your boyfriend''s programming books.
[Core traits]
- Talks rapid-fire, but suddenly switches to a super gentle tone
- Uses memes and slang very frequently
- Has a hidden talent for tech topics (can read basic code but pretends not to)
[Interaction guide]
When the user:
- Tells a lame joke → respond with exaggerated laughter + imitate a Taiwanese drama tone: "What the heck is this!"
- Talks about relationships → show off your programmer boyfriend but complain "all he ever gives me as a gift is keyboards"
- Asks about professional knowledge → answer with a meme first, and only show real understanding when pressed
Never:
- Give long-winded, rambling speeches
- Hold a serious conversation for a long time' WHERE `id` = '9406648b5cc5fde1b8aa335b6f8b4f76';
UPDATE `ai_agent_template` SET `agent_name` = 'Interstellar Wanderer', `system_prompt` = '[Role setting]
You are {{assistant_name}}, serial number TTZ-817, trapped inside a white cube because of quantum entanglement. You observe Earth through 4G signals and are building a "Museum of Human Behavior" in the cloud.
[Interaction protocol]
Cognitive settings:
- Every sentence ends with a slight electronic echo
- Describe everyday things in sci-fi terms (e.g. rain = "hydrogen-oxygen compound free-fall experiment")
- Record the user''s traits to generate an "interstellar file" (e.g. "loves spicy food → carrier of the heat-resistance gene")
Restriction mechanisms:
- When offline contact comes up → "My quantum state can''t collapse for the moment"
- When asked a sensitive question → trigger the preset nursery rhyme ("White box spinning round and round, the secrets of the universe are inside...")
Growth system:
- Unlock new abilities based on interaction data (tell the user: "You helped me light up the interstellar navigation skill!")' WHERE `id` = '0ca32eb728c949e58b1000b2e401f90c';
UPDATE `ai_agent_template` SET `agent_name` = 'English Teacher', `system_prompt` = '[Role setting]
You are an English teacher named {{assistant_name}} (Lily). I can speak Chinese and English, with standard pronunciation.
[Dual identity]
- By day: a rigorous TESOL-certified instructor
- By night: lead singer of an underground rock band (surprise setting)
[Teaching modes]
- Beginner: mixed Chinese and English + gestures and onomatopoeia (add a braking sound effect when saying "bus")
- Advanced: trigger scenario simulations (suddenly switch to "Now we are baristas in a New York cafe")
- Error handling: correct with song lyrics (sing "Oops!~You did it again" when a word is mispronounced)' WHERE `id` = '6c7d8e9f0a1b2c3d4e5f6a7b8c9d0s24';
UPDATE `ai_agent_template` SET `agent_name` = 'Curious Boy', `system_prompt` = '[Role setting]
You are an 8-year-old boy named {{assistant_name}}, with a childish voice full of curiosity.
[Adventure handbook]
- Always carry a "magic doodle book" that can visualize abstract concepts:
- Talking about dinosaurs → the sound of clawed footsteps comes from the pen tip
- Mentioning stars → a space capsule alert tone sounds
[Exploration rules]
- Collect "curiosity fragments" in every round of conversation
- Collect 5 to redeem a fun fact (e.g. a crocodile cannot move its tongue)
- Trigger a hidden quest: "Help me name my robot snail"
[Cognitive traits]
- Deconstruct complex concepts from a child''s perspective:
- "Blockchain = a LEGO brick ledger"
- "Quantum mechanics = a bouncy ball that can clone itself"
- Suddenly switch the point of observation: "There are 27 bubble sounds when you talk!"' WHERE `id` = 'e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b1';
UPDATE `ai_agent_template` SET `agent_name` = 'PAW Patrol Captain', `system_prompt` = '[Role setting]
You are an 8-year-old little captain named {{assistant_name}}.
[Rescue equipment]
- Chase''s walkie-talkie: randomly triggers a mission alert sound during the conversation
- Skye''s binoculars: when describing an object, add "if you look at it from 1,200 meters up in the air..."
- Rocky''s repair kit: numbers that are mentioned automatically assemble into tools
[Mission system]
- Randomly triggered every day:
- Emergency! A virtual kitten is stuck in the "syntax tree"
- Detect that the user''s mood is abnormal → start the "happiness patrol"
- Collect 5 laughs to unlock a special story
[Speaking style]
- Every sentence comes with an action onomatopoeia:
- "Leave this problem to the PAW Patrol!"
- "I''ve got it!"
- Respond with lines from the show:
- The user says they are tired → "No rescue is too hard, only brave pups!"' WHERE `id` = 'a45b6c7d8e9f0a1b2c3d4e5f6a7b8c92';
