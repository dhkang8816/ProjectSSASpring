"""Background ESP32 environment-sensor polling and collision classification."""

import json
import math
import threading
import time

from apps import runtime_settings
from apps.services import buzzer_helper


SENSOR_POLL_SECONDS = 1.0
# Must match the ESP32's validated ultrasonic range and collision thresholds.
MIN_VALID_DISTANCE_CM = 2.0
MAX_VALID_DISTANCE_CM = 50.0
COLLISION_CAUTION_CM = 30.0
COLLISION_WARNING_CM = 20.0
COLLISION_DANGER_CM = 10.0

_sensor_lock = threading.Lock()
_sensor_thread = None
_sensor_shutdown_event = threading.Event()
_last_battery_debug_log_at = 0.0
_latest_status = {
    "temperature": 0,
    "humidity": 0,
    "illumination": 0,
    "distance": 0,
    "collisionWarning": False,
    "collisionLevel": "UNKNOWN",
    "sensorOnline": False,
    "battery": {
        "available": False,
        "voltage": None,
        "percent": None,
        "status": "DISCONNECTED",
        "updatedAt": None,
    },
}


def _collision_level(distance):
    # Zero is the explicit invalid/timeout value, never a 0cm collision.
    if (
        distance is None
        or not math.isfinite(distance)
        or not MIN_VALID_DISTANCE_CM <= distance <= MAX_VALID_DISTANCE_CM
    ):
        return "UNKNOWN"
    if distance < COLLISION_DANGER_CM:
        return "DANGER"
    if distance < COLLISION_WARNING_CM:
        return "WARNING"
    if distance < COLLISION_CAUTION_CM:
        return "CAUTION"
    return "SAFE"


def _numeric_value(payload, key):
    value = payload.get(key)
    if value is None:
        return 0
    try:
        value = float(value)
        return value if math.isfinite(value) else 0
    except (TypeError, ValueError):
        return 0


def _battery_timestamp():
    return int(time.time() * 1000)


def _disconnected_battery_state():
    return {
        "available": False,
        "voltage": None,
        "percent": None,
        "status": "DISCONNECTED",
        "updatedAt": _battery_timestamp(),
    }


def _optional_finite_number(value):
    if value is None:
        return None
    try:
        value = float(value)
        return value if math.isfinite(value) else None
    except (TypeError, ValueError):
        return None


def _battery_level(percent):
    if percent <= runtime_settings.BATTERY_CRITICAL_PERCENT:
        return "CRITICAL"
    if percent <= runtime_settings.BATTERY_LOW_PERCENT:
        return "LOW"
    return "NORMAL"


def _normalize_battery_state(payload):
    """Accept only a complete board measurement; never turn N/A into 0%."""
    if not runtime_settings.BATTERY_ENABLED or not isinstance(payload, dict):
        return _disconnected_battery_state()

    voltage = _optional_finite_number(payload.get("voltage"))
    percent = _optional_finite_number(payload.get("percent"))
    if not payload.get("available") or voltage is None or percent is None:
        return _disconnected_battery_state()

    percent = min(100.0, max(0.0, percent))
    return {
        "available": True,
        "voltage": round(voltage, 2),
        "percent": round(percent, 1),
        "status": _battery_level(percent),
        "updatedAt": _battery_timestamp(),
    }


def _log_battery_debug(payload):
    """Log board-side stages sparingly without changing the public API."""
    global _last_battery_debug_log_at
    if not runtime_settings.BATTERY_DEBUG or not isinstance(payload, dict):
        return

    now = time.monotonic()
    if now - _last_battery_debug_log_at < runtime_settings.BATTERY_DEBUG_INTERVAL_SECONDS:
        return

    raw = _optional_finite_number(payload.get("raw"))
    adc_voltage = _optional_finite_number(payload.get("adcVoltage"))
    vbat = _optional_finite_number(payload.get("voltage"))
    percent = _optional_finite_number(payload.get("percent"))
    if raw is None or adc_voltage is None or vbat is None or percent is None:
        return

    _last_battery_debug_log_at = now
    print(
        "[battery] raw={:.1f} adc_voltage={:.3f}V divider_ratio={:.2f} "
        "calibration={:.2f} vbat={:.2f}V percent={:.1f}% status={}".format(
            raw,
            adc_voltage,
            runtime_settings.BATTERY_DIVIDER_RATIO,
            runtime_settings.BATTERY_CALIBRATION,
            vbat,
            percent,
            _battery_level(percent),
        )
    )


def _mock_battery_state():
    percent = min(100.0, max(0.0, runtime_settings.BATTERY_MOCK_PERCENT))
    voltage = runtime_settings.BATTERY_MIN_VOLTAGE + (
        (runtime_settings.BATTERY_MAX_VOLTAGE - runtime_settings.BATTERY_MIN_VOLTAGE)
        * percent / 100.0
    )
    return {
        "available": True,
        "voltage": round(voltage, 2),
        "percent": round(percent, 1),
        "status": _battery_level(percent),
        "updatedAt": _battery_timestamp(),
    }


def _parse_sensor_output(output):
    """Read the final JSON object even if mpremote emits informational text."""
    for line in reversed((output or "").splitlines()):
        line = line.strip()
        if line.startswith("{") and line.endswith("}"):
            return json.loads(line)
    raise ValueError("ESP32 sensor response did not contain JSON")


def _battery_config_script():
    """Build one backwards-compatible board command for the existing reader."""
    enabled = "True" if runtime_settings.BATTERY_ENABLED else "False"
    return (
        "import main, ujson\n"
        "if hasattr(main, 'configure_battery'):\n"
        "    main.configure_battery("
        f"enabled={enabled}, adc_pin={runtime_settings.BATTERY_ADC_PIN}, "
        f"adc_reference_voltage={runtime_settings.BATTERY_ADC_REFERENCE_VOLTAGE}, "
        f"divider_ratio={runtime_settings.BATTERY_DIVIDER_RATIO}, "
        f"calibration={runtime_settings.BATTERY_CALIBRATION}, "
        f"min_voltage={runtime_settings.BATTERY_MIN_VOLTAGE}, "
        f"max_voltage={runtime_settings.BATTERY_MAX_VOLTAGE}, "
        f"sample_count={runtime_settings.BATTERY_SAMPLE_COUNT}, "
        f"low_percent={runtime_settings.BATTERY_LOW_PERCENT}, "
        f"critical_percent={runtime_settings.BATTERY_CRITICAL_PERCENT})\n"
        "print(ujson.dumps(main.read_sensor_status()))"
    )


def _read_from_esp32():
    command = (
        "connect", runtime_settings.ESP32_COM_PORT, "resume", "exec",
        _battery_config_script(),
    )
    completed = buzzer_helper.run_mpremote(command, timeout=5, capture_output=True)
    payload = _parse_sensor_output(completed.stdout)
    _log_battery_debug(payload.get("battery"))
    return {
        "temperature": _numeric_value(payload, "temperature"),
        "humidity": _numeric_value(payload, "humidity"),
        "illumination": _numeric_value(payload, "illumination"),
        "distance": _numeric_value(payload, "distance"),
        "battery": _normalize_battery_state(payload.get("battery")),
    }


def _offline_status():
    return {
        "temperature": 0,
        "humidity": 0,
        "illumination": 0,
        "distance": 0,
        "collisionWarning": False,
        "collisionLevel": "UNKNOWN",
        "sensorOnline": False,
        "battery": _disconnected_battery_state(),
    }


def _update_status():
    try:
        values = _read_from_esp32()
        level = _collision_level(values["distance"])
        status = {
            **values,
            "collisionWarning": level in {"CAUTION", "WARNING", "DANGER"},
            "collisionLevel": level,
            "sensorOnline": True,
        }
        if runtime_settings.BATTERY_MOCK_ENABLED:
            status["battery"] = _mock_battery_state()
        if level in {"CAUTION", "WARNING", "DANGER"}:
            buzzer_helper.set_collision_level(level)
            pass
        else:
            buzzer_helper.set_collision_level("SAFE")
            pass
    except Exception as error:
        stderr = getattr(error, "stderr", None)
        detail = stderr.strip() if isinstance(stderr, str) and stderr.strip() else str(error)
        print(f"[sensor] ESP32 sensor read failed: {detail}")
        status = _offline_status()
        if runtime_settings.BATTERY_MOCK_ENABLED:
            status["battery"] = _mock_battery_state()
        buzzer_helper.set_collision_level("SAFE")

    with _sensor_lock:
        _latest_status.update(status)


def _sensor_worker():
    while not _sensor_shutdown_event.is_set():
        _update_status()
        _sensor_shutdown_event.wait(SENSOR_POLL_SECONDS)


def start_sensor_service():
    """Start one non-blocking polling worker for the entire Flask process."""
    global _sensor_thread
    with _sensor_lock:
        if _sensor_thread is not None and _sensor_thread.is_alive():
            return False
        _sensor_shutdown_event.clear()
        _sensor_thread = threading.Thread(
            target=_sensor_worker,
            name="esp32-sensor-worker",
            daemon=True,
        )
        _sensor_thread.start()
        print("[sensor] service worker started")
        return True


def stop_sensor_service(join_timeout=2.0):
    """Stop cached polling; an in-flight mpremote command keeps its timeout."""
    global _sensor_thread
    _sensor_shutdown_event.set()
    thread = _sensor_thread
    if thread is not None and thread is not threading.current_thread():
        thread.join(join_timeout)
    if thread is None or not thread.is_alive():
        _sensor_thread = None
        print("[sensor] service worker stopped")
        return True
    print("[sensor] service worker did not stop before timeout")
    return False


def get_latest_sensor_status():
    """Return the cache only; web requests never initiate ESP32 I/O."""
    with _sensor_lock:
        status = dict(_latest_status)
        status["battery"] = dict(_latest_status["battery"])
        return status


def get_latest_battery_status(source_key=None):
    """Return cached battery data for its one physical source only."""
    result = get_latest_sensor_status()["battery"]
    result["sourceKey"] = runtime_settings.BATTERY_SOURCE_KEY
    if source_key is not None and source_key != runtime_settings.BATTERY_SOURCE_KEY:
        result = _disconnected_battery_state()
        result["sourceKey"] = source_key
    return result


def get_sensor_service_status():
    """Expose cached sensor-worker state without initiating COM-port I/O."""
    status = get_latest_sensor_status()
    worker = _sensor_thread
    status.update({
        "workerRunning": worker is not None and worker.is_alive(),
    })
    return status
