import os
import tempfile
import unittest
from unittest.mock import Mock, patch

import requests

from apps.services import notifier


class DiscordNotifierTest(unittest.TestCase):
    def test_missing_webhook_skips_network_call(self):
        with patch.object(notifier, "_webhook_url", return_value=""), \
                patch.object(notifier.requests, "post") as post:
            sent = notifier.send_discord_webhook("event")

        self.assertFalse(sent)
        post.assert_not_called()

    def test_existing_snapshot_is_sent_as_multipart_attachment(self):
        response = Mock()
        response.raise_for_status.return_value = None
        with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False) as image:
            image.write(b"test-image")
            image_path = image.name
        try:
            with patch.object(notifier, "_webhook_url", return_value="https://example.invalid/webhook"), \
                    patch.object(notifier.requests, "post", return_value=response) as post:
                sent = notifier.send_discord_webhook("event", image_path=image_path)

            self.assertTrue(sent)
            self.assertIn("files", post.call_args.kwargs)
            self.assertIn("payload_json", post.call_args.kwargs["data"])
        finally:
            os.unlink(image_path)

    def test_network_error_returns_false_without_raising_to_yolo(self):
        with patch.object(notifier, "_webhook_url", return_value="https://example.invalid/webhook"), \
                patch.object(notifier.requests, "post", side_effect=requests.RequestException("offline")):
            sent = notifier.send_discord_webhook("event")

        self.assertFalse(sent)


if __name__ == "__main__":
    unittest.main()
