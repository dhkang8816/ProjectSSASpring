import os
import threading
import unittest
from unittest.mock import patch

from apps.app import create_app
from apps.stream import views


class StreamHealthRouteTest(unittest.TestCase):

    def test_runtime_initialization_requires_token_and_starts_workers_asynchronously(self):
        started = threading.Event()
        token = "x" * 32
        with patch.dict(os.environ, {"SSA_FLASK_CONTROL_TOKEN": token}, clear=False), \
                patch("apps.services.starter.start_services", side_effect=started.set):
            app = create_app("testing")
            client = app.test_client()

            denied = client.post("/stream/admin/initialize")
            self.assertEqual(403, denied.status_code)

            accepted = client.post(
                "/stream/admin/initialize",
                headers={"X-SSA-Flask-Control-Token": token},
            )
            self.assertEqual(200, accepted.status_code)
            self.assertEqual("SUCCESS", accepted.get_json()["status"])
            self.assertTrue(started.wait(1.0))

            status = client.get(
                "/stream/admin/startup-status",
                headers={"X-SSA-Flask-Control-Token": token},
            )

        self.assertEqual(200, status.status_code)
        self.assertEqual("SUCCESS", status.get_json()["status"])
        self.assertTrue(status.get_json()["servicesStarted"])

    def test_shutdown_requires_token_and_uses_runtime_callback(self):
        shutdown_called = threading.Event()
        with patch.dict(os.environ, {"SSA_FLASK_CONTROL_TOKEN": "x" * 32}, clear=False), \
                patch("apps.services.starter.start_services") as start_services:
            app = create_app("testing")
            client = app.test_client()

            denied = client.post("/stream/admin/shutdown")
            self.assertEqual(403, denied.status_code)

            app.config["SSA_SERVER_SHUTDOWN"] = shutdown_called.set
            accepted = client.post(
                "/stream/admin/shutdown",
                headers={"X-SSA-Flask-Control-Token": "x" * 32},
            )

        self.assertEqual(200, accepted.status_code)
        self.assertEqual("SUCCESS", accepted.get_json()["status"])
        self.assertTrue(shutdown_called.wait(1.0))
        start_services.assert_not_called()

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
