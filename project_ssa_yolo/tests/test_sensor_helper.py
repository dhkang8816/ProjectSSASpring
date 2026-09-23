import unittest
from unittest.mock import Mock, patch

from apps import runtime_settings
from apps.services import sensor_helper


class CollisionLevelTest(unittest.TestCase):
    def test_invalid_or_out_of_range_distances_are_unknown(self):
        for distance in (None, float("nan"), 0, 1.9, 50.1):
            self.assertEqual("UNKNOWN", sensor_helper._collision_level(distance))

    def test_collision_thresholds_use_validated_ultrasonic_range(self):
        cases = {
            2.0: "DANGER",
            9.9: "DANGER",
            10.0: "WARNING",
            19.9: "WARNING",
            20.0: "CAUTION",
            29.9: "CAUTION",
            30.0: "SAFE",
            50.0: "SAFE",
        }
        for distance, expected in cases.items():
            with self.subTest(distance=distance):
                self.assertEqual(expected, sensor_helper._collision_level(distance))

    def test_sensor_output_parser_uses_last_json_line(self):
        parsed = sensor_helper._parse_sensor_output("mpremote info\n{\"distance\": 12.5}\n")
        self.assertEqual({"distance": 12.5}, parsed)

    def test_sensor_read_uses_the_shared_runtime_com_port(self):
        completed = Mock(stdout='{"distance": 12.5}')
        with patch.object(runtime_settings, "ESP32_COM_PORT", "COM77"), \
                patch.object(sensor_helper.buzzer_helper, "run_mpremote", return_value=completed) as run_mpremote:
            sensor_helper._read_from_esp32()

        self.assertEqual("COM77", run_mpremote.call_args.args[0][1])

    def test_sensor_command_configures_battery_inside_the_existing_mpremote_call(self):
        with patch.object(runtime_settings, "BATTERY_ADC_REFERENCE_VOLTAGE", 1.0), \
                patch.object(runtime_settings, "BATTERY_DIVIDER_RATIO", 5.02), \
                patch.object(runtime_settings, "BATTERY_MAX_VOLTAGE", 4.25):
            command = sensor_helper._battery_config_script()

        self.assertIn("configure_battery", command)
        self.assertIn("read_sensor_status", command)
        self.assertNotIn("serial.Serial", command)
        self.assertIn("adc_reference_voltage=1.0", command)
        self.assertIn("divider_ratio=5.02", command)
        self.assertIn("max_voltage=4.25", command)

    def test_battery_normalization_keeps_missing_measurements_disconnected(self):
        with patch.object(runtime_settings, "BATTERY_ENABLED", True):
            battery = sensor_helper._normalize_battery_state({"available": False})

        self.assertFalse(battery["available"])
        self.assertIsNone(battery["voltage"])
        self.assertIsNone(battery["percent"])
        self.assertEqual("DISCONNECTED", battery["status"])

    def test_battery_normalization_uses_configured_thresholds(self):
        payload = {"available": True, "voltage": 3.31, "percent": 9.8}
        with patch.object(runtime_settings, "BATTERY_ENABLED", True), \
                patch.object(runtime_settings, "BATTERY_CRITICAL_PERCENT", 10.0), \
                patch.object(runtime_settings, "BATTERY_LOW_PERCENT", 25.0):
            battery = sensor_helper._normalize_battery_state(payload)

        self.assertTrue(battery["available"])
        self.assertEqual(3.31, battery["voltage"])
        self.assertEqual(9.8, battery["percent"])
        self.assertEqual("CRITICAL", battery["status"])

    def test_esp32_final_vbat_is_not_scaled_again_in_flask(self):
        completed = Mock(stdout=(
            '{"temperature": 0, "humidity": 0, "illumination": 0, '
            '"distance": 0, "battery": {"available": true, '
            '"raw": 3398, "adcVoltage": 0.83, "voltage": 4.0, '
            '"percent": 80.0, "status": "NORMAL"}}'
        ))
        with patch.object(sensor_helper.buzzer_helper, "run_mpremote", return_value=completed):
            values = sensor_helper._read_from_esp32()

        self.assertEqual(4.0, values["battery"]["voltage"])
        self.assertEqual(80.0, values["battery"]["percent"])

    def test_non_physical_source_never_receives_the_esp32_battery_value(self):
        original_status = sensor_helper.get_latest_sensor_status()
        try:
            with sensor_helper._sensor_lock:
                sensor_helper._latest_status["battery"] = {
                    "available": True,
                    "voltage": 3.91,
                    "percent": 73.5,
                    "status": "NORMAL",
                    "updatedAt": 1,
                }
            with patch.object(runtime_settings, "BATTERY_SOURCE_KEY", "esp32"):
                battery = sensor_helper.get_latest_battery_status("video_1")

            self.assertFalse(battery["available"])
            self.assertIsNone(battery["percent"])
            self.assertEqual("video_1", battery["sourceKey"])
        finally:
            with sensor_helper._sensor_lock:
                sensor_helper._latest_status.clear()
                sensor_helper._latest_status.update(original_status)


if __name__ == "__main__":
    unittest.main()
