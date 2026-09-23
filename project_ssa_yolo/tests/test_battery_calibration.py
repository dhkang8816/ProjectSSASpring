"""Host-side checks for the MicroPython GPIO2 battery calculation."""

import importlib.util
import sys
import types
import unittest
from pathlib import Path
from unittest.mock import patch


class _FakePin:
    OUT = 1
    IN = 0

    def __init__(self, number, mode=None):
        self.number = number
        self.mode = mode
        self._value = 0

    def value(self, value=None):
        if value is not None:
            self._value = value
        return self._value


class _FakePwm:
    def __init__(self, pin):
        self.pin = pin

    def duty(self, value):
        self.duty_value = value

    def freq(self, value):
        self.frequency = value


class _FakeAdc:
    ATTN_11DB = 3
    raw_value = 0
    attenuation_pins = []

    def __init__(self, pin):
        self.pin = pin

    def atten(self, _value):
        self.attenuation_pins.append(self.pin.number)

    def read(self):
        return self.raw_value


class _FakeDht11:
    def __init__(self, _pin):
        pass

    def measure(self):
        pass

    def temperature(self):
        return 0

    def humidity(self):
        return 0


def _load_board_main():
    _FakeAdc.attenuation_pins = []
    machine = types.ModuleType("machine")
    machine.Pin = _FakePin
    machine.PWM = _FakePwm
    machine.ADC = _FakeAdc
    dht = types.ModuleType("dht")
    dht.DHT11 = _FakeDht11
    source = Path(__file__).resolve().parents[1] / "Thonny" / "main.py"
    spec = importlib.util.spec_from_file_location("test_esp32_board_main", source)
    module = importlib.util.module_from_spec(spec)
    with patch.dict(sys.modules, {"machine": machine, "dht": dht}):
        spec.loader.exec_module(module)
    return module


class BatteryCalibrationTest(unittest.TestCase):
    def setUp(self):
        self.board = _load_board_main()

    @staticmethod
    def _raw_for_vbat(voltage):
        return round(voltage / (1.0 * 5.02 * 0.96) * 4095)

    def test_board_defaults_match_the_gpio2_divider_reference_formula(self):
        self.assertEqual(2, self.board.BATTERY_ADC_PIN)
        self.assertEqual(1.0, self.board.BATTERY_ADC_REFERENCE_VOLTAGE)
        self.assertEqual(5.02, self.board.BATTERY_DIVIDER_RATIO)
        self.assertEqual(0.96, self.board.BATTERY_CALIBRATION)
        self.assertEqual(3.0, self.board.BATTERY_MIN_VOLTAGE)
        self.assertEqual(4.25, self.board.BATTERY_MAX_VOLTAGE)
        self.assertNotIn(2, _FakeAdc.attenuation_pins)

    def test_voltage_and_percent_use_final_restored_vbat(self):
        cases = (
            (4.25, 100.0),
            (4.00, 80.0),
            (3.00, 0.0),
            (2.80, 0.0),
        )
        for expected_voltage, expected_percent in cases:
            with self.subTest(vbat=expected_voltage):
                _FakeAdc.raw_value = self._raw_for_vbat(expected_voltage)
                result = self.board.read_battery_status()
                self.assertTrue(result["available"])
                self.assertAlmostEqual(expected_voltage, result["voltage"], places=2)
                self.assertAlmostEqual(expected_percent, result["percent"], places=1)
                self.assertIn("raw", result)
                self.assertIn("adcVoltage", result)


if __name__ == "__main__":
    unittest.main()
