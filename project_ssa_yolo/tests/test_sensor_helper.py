import unittest

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


if __name__ == "__main__":
    unittest.main()
