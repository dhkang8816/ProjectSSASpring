import unittest
from unittest.mock import Mock, patch

from apps.services import buzzer_helper


class BuzzerHelperTest(unittest.TestCase):
    def setUp(self):
        buzzer_helper.set_buzzer_enabled(True)
        buzzer_helper.set_collision_level("SAFE")

    def tearDown(self):
        buzzer_helper.set_buzzer_enabled(True)
        buzzer_helper.set_collision_level("SAFE")

    def test_disabled_sound_does_not_start_a_worker_or_enqueue(self):
        buzzer_helper.set_buzzer_enabled(False)
        with patch.object(buzzer_helper, "start_buzzer_service") as start_worker:
            accepted = buzzer_helper._enqueue("animal")

        self.assertFalse(accepted)
        start_worker.assert_not_called()

    def test_collision_sound_is_enqueued_only_when_level_changes(self):
        with patch.object(buzzer_helper, "_enqueue") as enqueue:
            buzzer_helper.set_collision_level("DANGER")
            buzzer_helper.set_collision_level("DANGER")

        enqueue.assert_called_once_with("collision:DANGER")

    def test_mpremote_uses_current_python_module_not_shell_path_lookup(self):
        completed = Mock()
        with patch.object(buzzer_helper.subprocess, "run", return_value=completed) as run:
            returned = buzzer_helper.run_mpremote(("version",), timeout=3, capture_output=True)

        self.assertIs(completed, returned)
        command = run.call_args.args[0]
        self.assertEqual([*buzzer_helper._MPREMOTE_PREFIX, "version"], command)
        self.assertFalse(run.call_args.kwargs["shell"])


if __name__ == "__main__":
    unittest.main()
