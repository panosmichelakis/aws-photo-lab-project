import json
import os
import subprocess
import urllib.parse
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, HTTPServer

TABLE_NAME = os.environ.get("TABLE_NAME")
BUCKET_NAME = os.environ.get("BUCKET_NAME")
REGION = os.environ.get("AWS_REGION", "eu-central-1")
APP_PORT = int(os.environ.get("APP_PORT", "8000"))


def _aws_cli(args):
    cmd = ["aws", "--region", REGION] + args
    output = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
    return output.decode("utf-8")


def _deserialize_value(value):
    if "S" in value:
        return value["S"]
    if "N" in value:
        number = value["N"]
        return int(number) if number.isdigit() else float(number)
    if "BOOL" in value:
        return bool(value["BOOL"])
    if "NULL" in value:
        return None
    if "M" in value:
        return {k: _deserialize_value(v) for k, v in value["M"].items()}
    if "L" in value:
        return [_deserialize_value(v) for v in value["L"]]
    return value


def _deserialize_item(item):
    return {k: _deserialize_value(v) for k, v in item.items()}


def _scan_items():
    if not TABLE_NAME:
        raise RuntimeError("TABLE_NAME is not set")

    raw = _aws_cli([
        "dynamodb",
        "scan",
        "--table-name",
        TABLE_NAME,
        "--output",
        "json",
    ])
    data = json.loads(raw)
    return [_deserialize_item(item) for item in data.get("Items", [])]


def _presign_url(object_key):
    if not BUCKET_NAME:
        raise RuntimeError("BUCKET_NAME is not set")

    target = f"s3://{BUCKET_NAME}/{object_key}"
    url = _aws_cli([
        "s3",
        "presign",
        target,
        "--expires-in",
        "3600",
    ])
    return url.strip()


class PhotoLabHandler(BaseHTTPRequestHandler):
    def _send_json(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path == "/health":
            self._send_json(HTTPStatus.OK, {"status": "ok"})
            return

        if path == "/items":
            try:
                items = _scan_items()
                self._send_json(HTTPStatus.OK, {"items": items})
            except Exception as exc:
                self._send_json(HTTPStatus.INTERNAL_SERVER_ERROR, {"error": str(exc)})
            return

        if path.startswith("/items/"):
            object_key = urllib.parse.unquote(path[len("/items/") :])
            if not object_key:
                self._send_json(HTTPStatus.BAD_REQUEST, {"error": "object_key is required"})
                return
            try:
                url = _presign_url(object_key)
                self._send_json(HTTPStatus.OK, {"url": url})
            except Exception as exc:
                self._send_json(HTTPStatus.INTERNAL_SERVER_ERROR, {"error": str(exc)})
            return

        self._send_json(HTTPStatus.NOT_FOUND, {"error": "not found"})

    def log_message(self, format, *args):
        return


def main():
    server = HTTPServer(("0.0.0.0", APP_PORT), PhotoLabHandler)
    server.serve_forever()


if __name__ == "__main__":
    main()
