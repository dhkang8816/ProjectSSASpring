"""Diagnose the ESP32-CAM HTTP MJPEG input without starting Flask or YOLO.

Run from ``project_ssa_yolo``:

    python scripts/diagnostics/esp32_stream_check.py

It opens one camera connection, waits for one decoded frame, reports elapsed
time and dimensions, then closes the response.  It never accesses COM ports,
starts a SourceWorker, runs YOLO inference, or changes ESP32-CAM state.
"""

import sys
import time
from pathlib import Path

from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT_ROOT))
load_dotenv(PROJECT_ROOT / ".env")

from apps import runtime_settings  # noqa: E402
from apps.services.esp32_mjpeg import Esp32MjpegCapture  # noqa: E402


def main():
    capture = Esp32MjpegCapture(
        runtime_settings.ESP32_STREAM_URL,
        connect_timeout_seconds=runtime_settings.ESP32_HTTP_CONNECT_TIMEOUT_SECONDS,
        read_timeout_seconds=runtime_settings.ESP32_HTTP_READ_TIMEOUT_SECONDS,
        max_buffer_bytes=runtime_settings.ESP32_MJPEG_BUFFER_MAX_BYTES,
    )
    started_at = time.monotonic()
    try:
        if not capture.open():
            print(f"OPEN FAILED: {capture.last_error}")
            return 1
        success, frame = capture.read()
        elapsed = time.monotonic() - started_at
        if not success or frame is None:
            print(f"FRAME FAILED after {elapsed:.2f}s: {capture.last_error}")
            return 2
        height, width = frame.shape[:2]
        print(f"OK: first frame in {elapsed:.2f}s ({width}x{height})")
        return 0
    finally:
        capture.release()


if __name__ == "__main__":
    raise SystemExit(main())
