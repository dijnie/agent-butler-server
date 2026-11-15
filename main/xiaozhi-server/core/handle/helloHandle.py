import time
import json
import uuid
import random
import asyncio
from typing import TYPE_CHECKING
from config.logger import setup_logging

if TYPE_CHECKING:
    from core.connection import ConnectionHandler
from core.utils.dialogue import Message
from core.utils.util import audio_to_data, audio_file_to_wav_bytes
from core.providers.tts.dto.dto import SentenceType
from core.utils.wakeup_word import WakeupWordsConfig
from core.handle.sendAudioHandle import sendAudioMessage, send_tts_message
from core.utils.util import remove_punctuation_and_length, opus_datas_to_wav_bytes
from core.providers.tools.device_mcp import (
    MCPClient,
    send_mcp_initialize_message,
    send_mcp_tools_list_request,
)

TAG = __name__
_wakeup_logger = setup_logging()

WAKEUP_CONFIG = {
    "refresh_time": 10,
    "responses": [
        "I'm always here, go ahead.",
        "I'm here, tell me anytime.",
        "Coming, coming, please tell me.",
        "Go ahead, I'm listening.",
        "Please speak, I'm ready.",
        "Please tell me your command.",
        "I'm listening carefully, go ahead.",
        "How can I help you?",
        "I'm here, waiting for your command.",
    ],
}

# Create the global wake-word config manager
wakeup_words_config = WakeupWordsConfig()

# Lock that prevents concurrent calls to wakeupWordsResponse
_wakeup_response_lock = asyncio.Lock()


async def handleHelloMessage(conn: "ConnectionHandler", msg_json):
    """Handle the hello message"""
    audio_params = msg_json.get("audio_params")
    if audio_params:
        format = audio_params.get("format")
        conn.logger.bind(tag=TAG).debug(f"Client audio format: {format}")
        conn.audio_format = format
        conn.welcome_msg["audio_params"] = audio_params
    features = msg_json.get("features")
    if features:
        conn.logger.bind(tag=TAG).debug(f"Client features: {features}")
        conn.features = features
        if features.get("mcp"):
            conn.logger.bind(tag=TAG).debug("Client supports MCP")
            conn.mcp_client = MCPClient()
        if features.get("aec"):
            conn.logger.bind(tag=TAG).debug("Client enabled server-side AEC")
            conn.client_aec = True

    await conn.websocket.send(json.dumps(conn.welcome_msg))

    # The device waits for the server hello before processing MCP messages.
    if features and features.get("mcp"):
        asyncio.create_task(send_mcp_initialize_message(conn))
        # Pre-send tools/list concurrently so the frame reaches the client ahead of the audio stream
        asyncio.create_task(send_mcp_tools_list_request(conn))


async def checkWakeupWords(conn: "ConnectionHandler", text):
    enable_wakeup_words_response_cache = conn.config[
        "enable_wakeup_words_response_cache"
    ]

    # Wait for tts initialization, at most 3 seconds
    start_time = time.time()
    while time.time() - start_time < 3:
        if conn.tts:
            break
        await asyncio.sleep(0.1)
    else:
        return False

    if not enable_wakeup_words_response_cache:
        return False

    _, filtered_text = remove_punctuation_and_length(text)
    if filtered_text not in conn.config.get("wakeup_words"):
        return False

    conn.just_woken_up = True
    await send_tts_message(conn, "start")

    # Get the current voice
    voice = getattr(conn.tts, "voice", "default")
    if not voice:
        voice = "default"

    # Get the wake-word reply config
    response = wakeup_words_config.get_wakeup_response(voice)
    if not response or not response.get("file_path"):
        response = {
            "voice": "default",
            "file_path": "config/assets/wakeup_words_short.wav",
            "time": 0,
            "text": "我在这里哦！",
        }

    # Get the audio data
    opus_packets = await audio_to_data(response.get("file_path"), use_cache=True)
    # Play the wake-word reply
    conn.client_abort = False

    # Treat the wake-word reply as a new session and generate a new sentence_id so the rate controller is reset
    conn.sentence_id = str(uuid.uuid4().hex)

    # Add to the dialogue
    conn.dialogue.put(Message(role="assistant", content=response.get("text")))
    conn.logger.bind(tag=TAG).info(f"Playing wake-word reply: {response.get('text')}")

    await sendAudioMessage(conn, SentenceType.FIRST, opus_packets, response.get("text"))
    asyncio.create_task(_finish_wakeup_reply(conn))

    # Check whether the wake-word reply needs to be updated
    if time.time() - response.get("time", 0) > WAKEUP_CONFIG["refresh_time"]:
        if not _wakeup_response_lock.locked():
            asyncio.create_task(wakeupWordsResponse(conn))
    return True


async def _finish_wakeup_reply(conn: "ConnectionHandler"):
    """Send stop only after the audio queue drains (order: all audio frames → stop), without blocking the receive loop meanwhile"""
    try:
        await sendAudioMessage(conn, SentenceType.LAST, [], None)
    except asyncio.CancelledError:
        raise
    except Exception as e:
        conn.logger.bind(tag=TAG).error(f"Failed to wrap up the wake-word reply: {e}")


async def wakeupWordsResponse(conn: "ConnectionHandler"):
    if not conn.tts:
        return

    try:
        # Try to acquire the lock; return if it cannot be acquired
        if not await _wakeup_response_lock.acquire():
            return

        # Pick a random reply from the predefined reply list
        result = random.choice(WAKEUP_CONFIG["responses"])
        if not result or len(result) == 0:
            return

        # Generate the TTS audio
        tts_result = await asyncio.to_thread(conn.tts.to_tts, result)
        if not tts_result:
            return

        # Get the current voice
        voice = getattr(conn.tts, "voice", "default")

        # The retained TTS audio is a file path rather than Opus frames: convert straight to wav at the target sample rate, skipping the lossy Opus round trip
        if isinstance(tts_result, str):
            wav_bytes = await asyncio.to_thread(
                audio_file_to_wav_bytes, tts_result, conn.sample_rate
            )
        else:
            wav_bytes = opus_datas_to_wav_bytes(tts_result, sample_rate=conn.sample_rate)
        file_path = wakeup_words_config.generate_file_path(voice)
        with open(file_path, "wb") as f:
            f.write(wav_bytes)
        # Update the config
        wakeup_words_config.update_wakeup_response(voice, file_path, result)
        # Overwriting the file changes mtime and invalidates the old cache, so pre-encode the new file right here;
        # the next wake-up hits the cache directly and the encoding cost stays off the wake-up response path
        await audio_to_data(file_path, use_cache=True)
    finally:
        # Make sure the lock is released in all cases
        if _wakeup_response_lock.locked():
            _wakeup_response_lock.release()


async def preheat_wakeup_audio_cache():
    """Warm up the wake-word audio encoding cache at process startup

    Compute the Opus encoding of wakeup_words/{voice}.wav once and put it in the global cache,
    so every later connection hits it directly, saving the hundreds of milliseconds of wav→PCM→Opus overhead.
    """
    # tts is not initialized at process startup, so conn.tts.voice is unavailable; warm up using the common fallback list
    preheat_voices = ["default", "female-shaonv", "male-qn-jingying"]
    fallback_path = "config/assets/wakeup_words_short.wav"
    for voice in preheat_voices:
        file_path = fallback_path
        try:
            response = wakeup_words_config.get_wakeup_response(voice)
            if response and response.get("file_path"):
                file_path = response["file_path"]
            await audio_to_data(file_path, use_cache=True)
        except Exception as e:
            _wakeup_logger.bind(tag=TAG).warning(
                f"Warm-up for voice={voice} failed: {e}"
            )
