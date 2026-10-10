import os
import logging

import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)


def get_conn():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        connect_timeout=3,
    )


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/items")
def items():
    try:
        with get_conn() as conn, conn.cursor() as cur:
            cur.execute("SELECT id, name FROM items ORDER BY id")
            rows = cur.fetchall()
        return jsonify(count=len(rows), items=[{"id": r[0], "name": r[1]} for r in rows])
    except KeyError as e:
        app.logger.error("missing environment variable: %s", e)
        return jsonify(error=f"missing environment variable {e}"), 500
    except Exception as e:
        app.logger.error("database error: %s", e)
        return jsonify(error="database unavailable"), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
