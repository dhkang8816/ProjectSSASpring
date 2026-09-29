"""Non-secret runtime settings with defaults that preserve the prototype setup."""

import os
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent


def _text(name, default):
    value = os.getenv(name)
    return value.strip() if value and value.strip() else default


def _float(name, default, minimum=0.0):
    try:
        value = float(_text(name, str(default)))
    except ValueError:
        return default
    return value if value >= minimum else default


def _int(name, default, minimum=0):
    try:
        value = int(_text(name, str(default)))
    except ValueError:
        return default
    return value if value >= minimum else default


def _bool(name, default=False):
    value = _text(name, "true" if default else "false").lower()
    return value in {"1", "true", "yes", "on"}


SPRING_HOST = _text("SSA_SPRING_HOST", "http://localhost:80/project_ssa_spring")
ESP32_STREAM_URL = _text("SSA_ESP32_STREAM_URL", "http://192.168.137.247:80/stream")
ESP32_COM_PORT = _text("SSA_ESP32_COM_PORT", "COM6")

# Battery telemetry is produced by the existing ESP32 sensor polling command;
# it never opens another serial connection.  The values below match the ESP32-S3
# board circuit: GPIO2 receives VBAT through a 40.2k / 10k divider, so the
# physical VBAT restoration ratio is (40.2 + 10) / 10 = 5.02.  The 1.0V raw
# scale preserves the board vendor's validated formula:
# raw / 4095 * 5.02 * 0.96.
BATTERY_ENABLED = _bool("SSA_BATTERY_ENABLED", True)
BATTERY_SOURCE_KEY = _text("SSA_BATTERY_SOURCE_KEY", "esp32")
if BATTERY_SOURCE_KEY not in {"video_1", "video_2", "video_3", "esp32"}:
    BATTERY_SOURCE_KEY = "esp32"
BATTERY_ADC_PIN = _int("SSA_BATTERY_ADC_PIN", 2, minimum=0)
BATTERY_ADC_REFERENCE_VOLTAGE = _float("SSA_BATTERY_ADC_REFERENCE_VOLTAGE", 1.0, minimum=0.1)
BATTERY_MIN_VOLTAGE = _float("SSA_BATTERY_MIN_VOLTAGE", 3.0, minimum=0.1)
BATTERY_MAX_VOLTAGE = _float("SSA_BATTERY_MAX_VOLTAGE", 4.25, minimum=0.1)
if BATTERY_MAX_VOLTAGE <= BATTERY_MIN_VOLTAGE:
    BATTERY_MIN_VOLTAGE, BATTERY_MAX_VOLTAGE = 3.0, 4.25
BATTERY_DIVIDER_RATIO = _float("SSA_BATTERY_DIVIDER_RATIO", 5.02, minimum=0.01)
BATTERY_CALIBRATION = _float("SSA_BATTERY_CALIBRATION", 0.96, minimum=0.01)
BATTERY_SAMPLE_COUNT = _int("SSA_BATTERY_SAMPLE_COUNT", 8, minimum=1)
BATTERY_LOW_PERCENT = _float("SSA_BATTERY_LOW_PERCENT", 25.0, minimum=0.0)
BATTERY_CRITICAL_PERCENT = _float("SSA_BATTERY_CRITICAL_PERCENT", 10.0, minimum=0.0)
if BATTERY_CRITICAL_PERCENT > BATTERY_LOW_PERCENT:
    BATTERY_CRITICAL_PERCENT, BATTERY_LOW_PERCENT = 10.0, 25.0
BATTERY_MOCK_ENABLED = _bool("SSA_BATTERY_MOCK_ENABLED", False)
BATTERY_MOCK_PERCENT = min(100.0, _float("SSA_BATTERY_MOCK_PERCENT", 80.0, minimum=0.0))
BATTERY_DEBUG = _bool("SSA_BATTERY_DEBUG", False)
BATTERY_DEBUG_INTERVAL_SECONDS = _float("SSA_BATTERY_DEBUG_INTERVAL_SECONDS", 30.0, minimum=1.0)
BUZZER_STARTUP_SOUND_ENABLED = _bool("SSA_BUZZER_STARTUP_SOUND_ENABLED", True)
YOLO_MODEL_PATH = _text(
    "SSA_YOLO_MODEL_PATH",
    str(PROJECT_ROOT / "runs" / "detect" / "my_yolov12_project" / "yolov8n_train-6" / "weights" / "best.pt"),
)
VIDEO_PATHS = {
    "video_1": _text("SSA_VIDEO_1_PATH", str(PROJECT_ROOT / "videos" / "streaming_0.mp4")),
    "video_2": _text("SSA_VIDEO_2_PATH", str(PROJECT_ROOT / "videos" / "streaming_3.mp4")),
    "video_3": _text("SSA_VIDEO_3_PATH", str(PROJECT_ROOT / "videos" / "streaming_2.mp4")),
}

# All detector workers are built from this one registry.  Adding a source only
# requires a setting here; routes and worker management do not hard-code keys.
VIDEO_SOURCES = {
    key: {"mode": "video", "uri": path}
    for key, path in VIDEO_PATHS.items()
}
VIDEO_SOURCES["esp32"] = {"mode": "esp32", "uri": ESP32_STREAM_URL}
DEFAULT_VIDEO_SOURCE_KEY = _text("SSA_DEFAULT_VIDEO_SOURCE", "video_1")
if DEFAULT_VIDEO_SOURCE_KEY not in VIDEO_SOURCES:
    DEFAULT_VIDEO_SOURCE_KEY = "video_1"

UPLOAD_ROOT = _text("SSA_UPLOAD_ROOT", "C:/upload")

YOLO_CONFIDENCE = _float("SSA_YOLO_CONFIDENCE", 0.50, minimum=0.0)
ANIMAL_UNDER_TARGET_SECONDS = _float("SSA_ANIMAL_UNDER_TARGET_SECONDS", 10.0, minimum=0.0)
ANIMAL_RECOVERY_SECONDS = _float("SSA_ANIMAL_RECOVERY_SECONDS", 2.5, minimum=0.0)
ALARM_COOLDOWN_SECONDS = _float("SSA_ALARM_COOLDOWN_SECONDS", 10.0, minimum=0.0)
ANIMAL_TARGET_REFRESH_SECONDS = _float("SSA_ANIMAL_TARGET_REFRESH_SECONDS", 15.0, minimum=1.0)
METADATA_REQUEST_TIMEOUT_SECONDS = _float("SSA_METADATA_REQUEST_TIMEOUT_SECONDS", 1.0, minimum=0.1)
EVENT_REQUEST_TIMEOUT_SECONDS = _float("SSA_EVENT_REQUEST_TIMEOUT_SECONDS", 3.0, minimum=0.1)
MAPPING_REQUEST_TIMEOUT_SECONDS = _float("SSA_MAPPING_REQUEST_TIMEOUT_SECONDS", 1.0, minimum=0.1)
ESP32_CAPTURE_TIMEOUT_MS = _int("SSA_ESP32_CAPTURE_TIMEOUT_MS", 1000, minimum=1)
ESP32_RECEIVER_JOIN_TIMEOUT_SECONDS = _float("SSA_ESP32_RECEIVER_JOIN_TIMEOUT_SECONDS", 1.5, minimum=0.1)
SOURCE_WORKER_STOP_TIMEOUT_SECONDS = _float("SSA_SOURCE_WORKER_STOP_TIMEOUT_SECONDS", 5.0, minimum=0.1)
SOURCE_WORKER_FRAME_INTERVAL_SECONDS = _float("SSA_SOURCE_WORKER_FRAME_INTERVAL_SECONDS", 0.03, minimum=0.0)
SOURCE_WORKER_RETRY_SECONDS = _float("SSA_SOURCE_WORKER_RETRY_SECONDS", 0.5, minimum=0.05)
AUTO_START_DETECTION_WORKERS = _bool("SSA_AUTO_START_DETECTION_WORKERS", False)
