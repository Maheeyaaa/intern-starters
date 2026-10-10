import json
import logging
import os
import time
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)

# Read the key if needed by the application, but never log its value.
API_KEY = os.environ.get("DUMMY_API_KEY", "")
_held = []

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger("observability")


def log_event(level, event, **fields):
    record = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "level": level,
        "event": event,
        **fields,
    }
    getattr(logger, level.lower())(json.dumps(record))


log_event("INFO", "service_started", environment="training")


@app.get("/health")
def health():
    return jsonify(status="healthy"), 200


@app.get("/")
def index():
    log_event("INFO", "status_requested")
    return jsonify(status="ok")


@app.get("/work")
def work():
    time.sleep(0.2)
    log_event("INFO", "work_completed")
    return jsonify(done=True)


@app.get("/leak")
def leak():
    log_event("WARNING", "leak_endpoint_disabled")
    return jsonify(error="Endpoint disabled after memory leak incident"), 410


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
