#!/usr/bin/env bash
set -euo pipefail

. "$(dirname "$0")/common.sh"

BACKUP_FILE="${1:-}"

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup-file-path>" >&2
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ] || [ ! -s "$BACKUP_FILE" ]; then
  echo "ERROR: backup file is missing or empty: $BACKUP_FILE" >&2
  exit 1
fi

wait_for_db
docker compose exec -T db psql \
  -v ON_ERROR_STOP=1 \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" < "$BACKUP_FILE"

echo "Restore completed: $BACKUP_FILE"
