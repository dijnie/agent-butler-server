import time
import asyncio
from collections import deque
from config.logger import setup_logging

TAG = __name__
logger = setup_logging()


class AudioRateController:
    """
    Audio rate controller - precisely paces audio sending at a 60ms frame duration
    Solves the accumulated timing error under high concurrency
    """

    def __init__(self, frame_duration=60, send_delay=0):
        """
        Args:
            frame_duration: duration of a single audio frame (ms), 60ms by default
            send_delay: custom send interval (ms).
                        0 = send at the frame_duration pace;
                        >0 = send at the send_delay pace (no queueing delay on the main thread, no pre-buffering)
        """
        # Flow control interval (ms): the configured value when send_delay > 0, otherwise frame_duration
        self.interval_ms = send_delay if send_delay > 0 else frame_duration
        self.queue = deque()
        self.play_position = 0  # Virtual playback position (ms)
        self.start_timestamp = None  # Start timestamp (read-only, not modified)
        self.pending_send_task = None
        self.logger = logger
        self.queue_empty_event = asyncio.Event()  # Queue-empty event
        self.queue_empty_event.set()  # Initially empty
        self.queue_has_data_event = asyncio.Event()  # Queue-has-data event
        self._last_queue_empty_time = 0  # Time the queue was last emptied (seconds)

    def reset(self):
        """Reset the controller state"""
        if self.pending_send_task and not self.pending_send_task.done():
            self.pending_send_task.cancel()
            # After cancelling, the task is cleaned up on the next event loop iteration; no need to block waiting

        self.queue.clear()
        self.play_position = 0
        self.start_timestamp = None  # Set by the first audio packet
        self._last_queue_empty_time = 0  # Reset the time
        # Related event handling
        self.queue_empty_event.set()
        self.queue_has_data_event.clear()

    def add_audio(self, opus_packet):
        """Add an audio packet to the queue"""
        # If the queue was empty before, adjust the timestamp to keep playback time continuous
        # so that audio added after waiting on e.g. a tool call does not play early
        # If the gap is very short (<1 frame), it is normal streaming and no reset is needed
        if len(self.queue) == 0 and self.play_position > 0:
            elapsed_since_empty = (time.monotonic() - self._last_queue_empty_time) * 1000
            # Only a gap longer than one frame duration counts as a real "pause and resume"
            if elapsed_since_empty >= self.interval_ms:
                self.start_timestamp = time.monotonic() - (self.play_position / 1000)
                self.logger.bind(tag=TAG).debug(
                    f"Queue resumed from empty, resetting timestamp, current playback position: {self.play_position}ms, gap: {elapsed_since_empty:.0f}ms"
                )

        self.queue.append(("audio", opus_packet))
        # Related event handling
        self.queue_empty_event.clear()
        self.queue_has_data_event.set()

    def add_message(self, message_callback):
        """
        Add a message to the queue (sent immediately, takes no playback time)

        Args:
            message_callback: message send callback async def()
        """
        if len(self.queue) == 0 and self.play_position > 0:
            elapsed_since_empty = (time.monotonic() - self._last_queue_empty_time) * 1000
            if elapsed_since_empty >= self.interval_ms:
                self.start_timestamp = time.monotonic() - (self.play_position / 1000)
                self.logger.bind(tag=TAG).debug(
                    f"Queue resumed from empty, resetting timestamp, current playback position: {self.play_position}ms, gap: {elapsed_since_empty:.0f}ms"
                )

        self.queue.append(("message", message_callback))
        # Related event handling
        self.queue_empty_event.clear()
        self.queue_has_data_event.set()

    def _get_elapsed_ms(self):
        """Get the elapsed time (ms)"""
        if self.start_timestamp is None:
            return 0
        return (time.monotonic() - self.start_timestamp) * 1000

    async def check_queue(self, send_audio_callback):
        """
        Check the queue and send audio/messages on time

        Args:
            send_audio_callback: callback for sending audio async def(opus_packet)
        """
        while self.queue:
            item = self.queue[0]
            item_type = item[0]

            if item_type == "message":
                # Message type: sent immediately, takes no playback time
                _, message_callback = item
                self.queue.popleft()
                try:
                    await message_callback()
                except Exception as e:
                    self.logger.bind(tag=TAG).error(f"Failed to send message: {e}")
                    raise

            elif item_type == "audio":
                if self.start_timestamp is None:
                    self.start_timestamp = time.monotonic()

                _, opus_packet = item

                # Loop until the time is reached
                while True:
                    # Compute the time difference
                    elapsed_ms = self._get_elapsed_ms()
                    output_ms = self.play_position

                    if elapsed_ms < output_ms:
                        # Not yet time to send; compute how long to wait
                        wait_ms = output_ms - elapsed_ms

                        # Keep checking after the wait (interruptible)
                        try:
                            await asyncio.sleep(wait_ms / 1000)
                        except asyncio.CancelledError:
                            self.logger.bind(tag=TAG).debug("Audio send task cancelled")
                            raise
                        # Re-check the time after the wait (loop back to while True)
                    else:
                        # Time reached, leave the wait loop
                        break

                # Time reached, remove from the queue and send
                self.queue.popleft()
                self.play_position += self.interval_ms
                try:
                    await send_audio_callback(opus_packet)
                except Exception as e:
                    self.logger.bind(tag=TAG).error(f"Failed to send audio: {e}")
                    raise

        # Clear the event once the queue is processed
        self.queue_empty_event.set()
        self.queue_has_data_event.clear()
        self._last_queue_empty_time = time.monotonic()  # Record when the queue was emptied

    def start_sending(self, send_audio_callback):
        """
        Start the async send task

        Args:
            send_audio_callback: callback for sending audio

        Returns:
            asyncio.Task: the send task
        """

        async def _send_loop():
            try:
                while True:
                    # Wait on the queue-has-data event instead of polling and burning CPU
                    await self.queue_has_data_event.wait()

                    await self.check_queue(send_audio_callback)
            except asyncio.CancelledError:
                self.logger.bind(tag=TAG).debug("Audio send loop stopped")
            except Exception as e:
                self.logger.bind(tag=TAG).error(f"Audio send loop error: {e}")

        self.pending_send_task = asyncio.create_task(_send_loop())
        return self.pending_send_task

    def stop_sending(self):
        """Stop the send task"""
        if self.pending_send_task and not self.pending_send_task.done():
            self.pending_send_task.cancel()
            self.logger.bind(tag=TAG).debug("Audio send task cancelled")
