#!/usr/bin/env bash
# Shared helpers. Loads .env and provides psql and wait helpers.
set -a; . ./.env; set +a

psql_db() {
  docker compose exec -T db psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$@"
}

wait_for_db() {
  for _ in $(seq 1 30); do
    if docker compose exec -T db pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; then return 0; fi
    sleep 2
  done
  echo "database did not become ready" >&2; return 1
}
