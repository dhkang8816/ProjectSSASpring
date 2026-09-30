"""Application service bootstrap helpers."""

import threading

from apps import runtime_settings
from apps.services.buzzer_helper import (
    play_startup_melody,
    play_shutdown_melody,
    is_buzzer_service_running,
    start_buzzer_service,
    stop_buzzer_service,
)
from apps.services.notifier import start_notification_service, stop_notification_service
from apps.services.sensor_helper import start_sensor_service, stop_sensor_service


_startup_sound_lock = threading.Lock()
_startup_sound_played = False


def start_services():
    """Initialize optional workers and queue at most one process startup tone."""

    global _startup_sound_played
    print("[starter] services starting")
    start_buzzer_service()
    start_sensor_service()
    start_notification_service()

    if runtime_settings.BUZZER_STARTUP_SOUND_ENABLED:
        with _startup_sound_lock:
            if not _startup_sound_played:
                # This only enqueues.  ESP32/mpremote failures stay in the existing
                # worker and must never make Flask startup fail.
                play_startup_melody()
                _startup_sound_played = True
    print("[starter] services ready")


def stop_services():
    """Stop optional background services during Flask process shutdown."""
    stop_notification_service()
    stop_sensor_service()
    # The sensor poller and buzzer share one mpremote lock.  Stop polling
    # first, then give the queued shutdown tone a bounded chance to own COM6.
    # A muted console intentionally stays silent during shutdown as well.
    if (
        runtime_settings.BUZZER_SHUTDOWN_SOUND_ENABLED
        and is_buzzer_service_running()
    ):
        play_shutdown_melody(runtime_settings.BUZZER_SHUTDOWN_SOUND_WAIT_SECONDS)
    stop_buzzer_service()
