#!/usr/bin/env bash
set -euo pipefail

. "$(dirname "$0")/common.sh"

BACKUP_FILE="${1:-}"

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup-file-path>" >&2
  exit 1
fi

if [ -e "$BACKUP_FILE" ]; then
  echo "ERROR: backup file already exists: $BACKUP_FILE" >&2
  exit 1
fi

mkdir -p "$(dirname "$BACKUP_FILE")"
tmp_file=$(mktemp "${BACKUP_FILE}.tmp.XXXXXX")
trap 'rm -f "$tmp_file"' EXIT

wait_for_db
docker compose exec -T db pg_dump \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  --no-owner --no-acl > "$tmp_file"

if [ ! -s "$tmp_file" ]; then
  echo "ERROR: backup is empty" >&2
  exit 1
fi

mv "$tmp_file" "$BACKUP_FILE"
trap - EXIT
echo "Backup created: $BACKUP_FILE"
