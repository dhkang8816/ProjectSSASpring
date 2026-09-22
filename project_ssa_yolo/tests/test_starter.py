import unittest
from unittest.mock import patch

from apps.services import starter


class StarterTest(unittest.TestCase):
    def test_startup_melody_is_scheduled_once_after_services_are_ready(self):
        original_played = starter._startup_sound_played
        try:
            starter._startup_sound_played = False
            with patch.object(starter, "start_buzzer_service"), \
                    patch.object(starter, "start_sensor_service"), \
                    patch.object(starter, "start_notification_service"), \
                    patch.object(starter.runtime_settings, "BUZZER_STARTUP_SOUND_ENABLED", True), \
                    patch.object(starter, "play_startup_melody") as startup_melody:
                starter.start_services()
                starter.start_services()

            startup_melody.assert_called_once_with()
        finally:
            starter._startup_sound_played = original_played


if __name__ == "__main__":
    unittest.main()
