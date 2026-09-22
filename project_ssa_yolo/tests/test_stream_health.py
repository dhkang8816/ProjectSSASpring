import unittest
from unittest.mock import patch

from apps.app import create_app
from apps.stream import views


class StreamHealthRouteTest(unittest.TestCase):
    def test_health_returns_cached_status_without_starting_services(self):
        with patch("apps.services.starter.start_services") as start_services, \
                patch.object(views.yolo_detector, "get_default_source_key", return_value="video_1"), \
                patch.object(views.yolo_detector, "get_source_status", return_value={"video_1": {"running": True}}), \
                patch.object(views.sensor_helper, "get_sensor_service_status", return_value={"sensorOnline": True}), \
                patch.object(views.buzzer_helper, "get_buzzer_status", return_value={"enabled": True}), \
                patch.object(views.notifier, "get_notification_status", return_value={"configured": True}), \
                patch.object(views.yolo_detector, "start_source_worker") as start_yolo, \
                patch.object(views.buzzer_helper, "start_buzzer_service") as start_buzzer:
            app = create_app("testing")
            response = app.test_client().get("/stream/health")

        self.assertEqual(200, response.status_code)
        self.assertEqual("video_1", response.get_json()["default_source"])
        self.assertTrue(response.get_json()["sensor"]["sensorOnline"])
        start_services.assert_not_called()
        start_yolo.assert_not_called()
        start_buzzer.assert_not_called()

    def test_battery_route_returns_cached_status_without_direct_serial_access(self):
        battery = {
            "available": True,
            "voltage": 3.91,
            "percent": 73.5,
            "status": "NORMAL",
            "updatedAt": 1,
            "sourceKey": "esp32",
        }
        with patch("apps.services.starter.start_services") as start_services, \
                patch.object(views.sensor_helper, "get_latest_battery_status", return_value=battery) as cached_battery:
            app = create_app("testing")
            response = app.test_client().get("/stream/battery/status")

        self.assertEqual(200, response.status_code)
        self.assertEqual(73.5, response.get_json()["percent"])
        cached_battery.assert_called_once_with()
        start_services.assert_called_once()


if __name__ == "__main__":
    unittest.main()
