#!/usr/bin/env bash
# Seeds data, recreates the container, and compares before/after.
. "$(dirname "$0")/common.sh"
docker compose up -d
./scripts/seed.sh
before=$(./scripts/baseline.sh 2>&1)
echo "BEFORE: $before"
docker compose down
docker compose up -d
wait_for_db
after=$(./scripts/baseline.sh 2>&1)
echo "AFTER:  $after"
if [ "$before" = "$after" ]; then echo "PASS: data survived container recreation"; else echo "FAIL: data did not survive container recreation"; exit 1; fi
