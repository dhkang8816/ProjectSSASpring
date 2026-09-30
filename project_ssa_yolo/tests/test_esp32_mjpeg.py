import cv2
import numpy as np

from apps.services.esp32_mjpeg import Esp32MjpegCapture


class _FakeResponse:
    def __init__(self, chunks, status_error=None):
        self._chunks = chunks
        self._status_error = status_error
        self.closed = False

    def raise_for_status(self):
        if self._status_error is not None:
            raise self._status_error

    def iter_content(self, chunk_size):
        yield from self._chunks

    def close(self):
        self.closed = True


class _FakeSession:
    def __init__(self, response):
        self.response = response
        self.calls = []
        self.closed = False
        self.trust_env = True

    def get(self, url, **kwargs):
        self.calls.append((url, kwargs))
        return self.response

    def close(self):
        self.closed = True


def _jpeg(color):
    frame = np.full((4, 6, 3), color, dtype=np.uint8)
    encoded, buffer = cv2.imencode(".jpg", frame)
    assert encoded
    return buffer.tobytes()


def test_reader_decodes_split_frames_and_keeps_one_http_connection():
    first, second = _jpeg(20), _jpeg(180)
    response = _FakeResponse([
        b"--frame\r\nContent-Type: image/jpeg\r\n\r\n" + first[:13],
        first[13:] + b"\r\n--frame\r\n" + second,
    ])
    session = _FakeSession(response)
    reader = Esp32MjpegCapture(
        "http://camera/stream",
        connect_timeout_seconds=8,
        read_timeout_seconds=2,
        max_buffer_bytes=1024 * 1024,
        session_factory=lambda: session,
    )

    assert reader.open()
    success, first_frame = reader.read()
    assert success and first_frame.shape == (4, 6, 3)
    success, second_frame = reader.read()
    assert success and second_frame.shape == (4, 6, 3)
    assert len(session.calls) == 1
    assert session.calls[0][1]["stream"] is True
    assert session.calls[0][1]["timeout"] == (8, 2)
    assert session.trust_env is False

    reader.release()
    assert response.closed
    assert session.closed


def test_reader_bounds_invalid_data_and_closes_when_stream_ends():
    response = _FakeResponse([b"x" * 128])
    session = _FakeSession(response)
    reader = Esp32MjpegCapture(
        "http://camera/stream",
        connect_timeout_seconds=8,
        read_timeout_seconds=2,
        max_buffer_bytes=64,
        session_factory=lambda: session,
    )

    assert reader.open()
    success, frame = reader.read()
    assert not success and frame is None
    assert not reader.isOpened()
    assert response.closed
    assert session.closed
