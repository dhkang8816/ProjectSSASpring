"""Regression tests for animal-under-target alerts."""

import unittest
from unittest.mock import patch

from apps.services import yolo_detector


class AnimalUnderTargetPolicyTest(unittest.TestCase):
    SOURCE_KEY = "video_1"

    def setUp(self):
        with yolo_detector._event_state_lock:
            yolo_detector.under_target_start_time.clear()
            yolo_detector.recovery_start_time.clear()
            yolo_detector.last_alarm_time.clear()

        self.settings = patch.multiple(
            yolo_detector.runtime_settings,
            ANIMAL_UNDER_TARGET_SECONDS=10.0,
            ANIMAL_RECOVERY_SECONDS=2.5,
        )
        self.targets = patch.object(yolo_detector, "TARGET_ANIMALS", {"0": 2, "1": 1})
        self.names = patch.object(yolo_detector, "ANIMAL_NAME_MAP", {"dog": "개", "cat": "고양이"})
        self.cooldown = patch.object(yolo_detector, "ALARM_COOLDOWN", 10.0)
        self.duration = patch.object(yolo_detector, "ANIMAL_UNDER_TARGET_SECONDS", 10.0)
        self.policy_version = patch.object(yolo_detector, "_animal_policy_version", "test-v1")
        self.refresh = patch.object(yolo_detector, "refresh_animal_targets_if_due")
        self.settings.start()
        self.targets.start()
        self.names.start()
        self.cooldown.start()
        self.duration.start()
        self.policy_version.start()
        self.refresh.start()

    def tearDown(self):
        self.cooldown.stop()
        self.names.stop()
        self.targets.stop()
        self.settings.stop()
        self.refresh.stop()
        self.policy_version.stop()
        self.duration.stop()
        with yolo_detector._event_state_lock:
            yolo_detector.under_target_start_time.clear()
            yolo_detector.recovery_start_time.clear()
            yolo_detector.last_alarm_time.clear()

    def test_no_animal_detection_never_starts_under_target_timers(self):
        with patch.object(yolo_detector.time, "time", side_effect=(0.0, 15.0)), \
                patch.object(yolo_detector.oracle_service, "send_log_to_oracle") as send_log, \
                patch.object(yolo_detector, "trigger_animal_sound") as trigger_sound:
            yolo_detector.process_animal_detection_logic([], None, self.SOURCE_KEY)
            yolo_detector.process_animal_detection_logic([], None, self.SOURCE_KEY)

        send_log.assert_not_called()
        trigger_sound.assert_not_called()
        self.assertEqual(
            {"0": None, "1": None},
            yolo_detector.under_target_start_time[self.SOURCE_KEY],
        )

    def test_detected_animal_starts_timer_for_its_missing_protected_peer(self):
        frame = object()
        with patch.object(yolo_detector.time, "time", side_effect=(0.0, 10.1)), \
                patch.object(yolo_detector.oracle_service, "send_log_to_oracle") as send_log, \
                patch.object(yolo_detector, "trigger_animal_sound") as trigger_sound:
            yolo_detector.process_animal_detection_logic(["dog"], frame, self.SOURCE_KEY)
            yolo_detector.process_animal_detection_logic(["dog"], frame, self.SOURCE_KEY)

        self.assertEqual(2, send_log.call_count)
        self.assertCountEqual(
            ["0", "1"],
            [call.kwargs["animal_type"] for call in send_log.call_args_list],
        )
        self.assertCountEqual(
            [1, 0],
            [call.kwargs["detect_count"] for call in send_log.call_args_list],
        )
        self.assertEqual(2, trigger_sound.call_count)

    def test_lost_detection_clears_pending_timer_instead_of_firing_later(self):
        with patch.object(yolo_detector.time, "time", side_effect=(0.0, 5.0, 11.0, 21.1)), \
                patch.object(yolo_detector.oracle_service, "send_log_to_oracle") as send_log, \
                patch.object(yolo_detector, "trigger_animal_sound") as trigger_sound:
            yolo_detector.process_animal_detection_logic(["dog"], None, self.SOURCE_KEY)
            yolo_detector.process_animal_detection_logic([], None, self.SOURCE_KEY)
            yolo_detector.process_animal_detection_logic(["dog"], None, self.SOURCE_KEY)
            yolo_detector.process_animal_detection_logic(["dog"], None, self.SOURCE_KEY)

        send_log.assert_called_once()
        trigger_sound.assert_called_once()

    def test_policy_change_restarts_pending_shortage_duration(self):
        with patch.object(yolo_detector.time, "time", side_effect=(0.0, 11.0)), \
                patch.object(yolo_detector.oracle_service, "send_log_to_oracle") as send_log, \
                patch.object(yolo_detector, "trigger_animal_sound") as trigger_sound:
            yolo_detector.process_animal_detection_logic(["dog"], None, self.SOURCE_KEY)
            changed = yolo_detector._apply_animal_shortage_policy({
                "underTargetSeconds": 20.0,
                "version": "test-v2",
            })
            yolo_detector.process_animal_detection_logic(["dog"], None, self.SOURCE_KEY)

        self.assertTrue(changed)
        send_log.assert_not_called()
        trigger_sound.assert_not_called()


if __name__ == "__main__":
    unittest.main()
