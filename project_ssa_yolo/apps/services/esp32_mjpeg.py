"""Small, bounded HTTP MJPEG reader for the ESP32-CAM source only.

The camera firmware serves a multipart HTTP response that browsers decode
reliably but OpenCV/FFmpeg can abandon while it is still opening.  This object
has the tiny ``VideoCapture`` surface used by ``SourceWorker`` so the worker
continues to own exactly one input connection and the existing YOLO pipeline
does not need to know which reader supplied the frame.
"""

import cv2
import numpy as np
import requests


_JPEG_SOI = b"\xff\xd8"
_JPEG_EOI = b"\xff\xd9"


class Esp32MjpegCapture:
    """Read JPEG frames from one HTTP MJPEG response without buffering history."""

    def __init__(
        self,
        url,
        *,
        connect_timeout_seconds,
        read_timeout_seconds,
        max_buffer_bytes,
        session_factory=requests.Session,
    ):
        self.url = url
        self.connect_timeout_seconds = connect_timeout_seconds
        self.read_timeout_seconds = read_timeout_seconds
        self.max_buffer_bytes = max_buffer_bytes
        self._session_factory = session_factory
        self._session = None
        self._response = None
        self._chunks = None
        self._buffer = bytearray()
        self._opened = False
        self.last_error = None

    def open(self):
        """Open exactly one streaming response for this capture instance."""
        if self._opened:
            return True
        self.last_error = None
        try:
            self._session = self._session_factory()
            # ESP32-CAM is a local hotspot device.  A system HTTP proxy must
            # never receive this private-network stream request.
            if hasattr(self._session, "trust_env"):
                self._session.trust_env = False
            response = self._session.get(
                self.url,
                stream=True,
                timeout=(self.connect_timeout_seconds, self.read_timeout_seconds),
                headers={"Accept": "multipart/x-mixed-replace, image/jpeg"},
            )
            response.raise_for_status()
            self._response = response
            self._chunks = iter(response.iter_content(chunk_size=4096))
            self._opened = True
            return True
        except (OSError, requests.RequestException) as error:
            self.last_error = f"ESP32 MJPEG open failed: {error}"
            self.release()
            return False

    def isOpened(self):
        return self._opened

    def read(self):
        """Return one decoded JPEG frame, or ``(False, None)`` on disconnect."""
        if not self._opened:
            return False, None

        while self._opened:
            jpeg = self._pop_jpeg()
            if jpeg is not None:
                frame = cv2.imdecode(np.frombuffer(jpeg, dtype=np.uint8), cv2.IMREAD_COLOR)
                if frame is not None:
                    return True, frame
                # Corrupt JPEGs should not terminate an otherwise healthy
                # multipart response; discard that one frame and continue.
                self.last_error = "ESP32 MJPEG decode failed"
                continue

            try:
                chunk = next(self._chunks)
            except StopIteration:
                self.last_error = "ESP32 MJPEG stream ended"
                self.release()
                return False, None
            except (OSError, requests.RequestException) as error:
                self.last_error = f"ESP32 MJPEG read failed: {error}"
                self.release()
                return False, None

            if chunk:
                self._append(chunk)

        return False, None

    def release(self):
        """Close the response and session.  SourceWorker calls this in its finally block."""
        response, session = self._response, self._session
        self._opened = False
        self._response = None
        self._session = None
        self._chunks = None
        self._buffer.clear()
        if response is not None:
            try:
                response.close()
            except OSError:
                pass
        if session is not None:
            try:
                session.close()
            except OSError:
                pass

    def _append(self, chunk):
        if len(chunk) >= self.max_buffer_bytes:
            self._buffer.clear()
            self.last_error = "ESP32 MJPEG frame exceeded bounded buffer"
            return
        if len(self._buffer) + len(chunk) > self.max_buffer_bytes:
            # An incomplete/invalid frame must never grow without bound.
            self._buffer.clear()
            self.last_error = "ESP32 MJPEG buffer reset after invalid frame"
        self._buffer.extend(chunk)

    def _pop_jpeg(self):
        start = self._buffer.find(_JPEG_SOI)
        if start < 0:
            # Keep a trailing 0xff because it may be the first half of a
            # start marker split across HTTP chunks.
            if len(self._buffer) > 1:
                trailing_marker = self._buffer[-1:] == b"\xff"
                self._buffer[:] = b"\xff" if trailing_marker else b""
            return None

        if start:
            del self._buffer[:start]

        end = self._buffer.find(_JPEG_EOI, len(_JPEG_SOI))
        if end < 0:
            return None

        end += len(_JPEG_EOI)
        jpeg = bytes(self._buffer[:end])
        del self._buffer[:end]
        return jpeg
