#!/usr/bin/env bash
# Verification checks for AUT-004. Run from this folder after your fixes.
pass=0; fail=0
check() {
  if eval "$2" >/dev/null 2>&1; then echo "PASS: $1"; pass=$((pass+1)); else echo "FAIL: $1"; fail=$((fail+1)); fi
}
check "web answers on http://localhost:8080/health" 'curl -fsS http://localhost:8080/health | grep -q ok'
check "/items returns 3 records through the web service" 'curl -fsS http://localhost:8080/items | grep -Eq "\"count\": ?3"'
check "db container reports healthy" '[ "$(docker inspect --format "{{.State.Health.Status}}" $(docker compose ps -q db))" = healthy ]'
check "api can reach db by service name" 'docker compose exec -T api python -c "import socket; socket.create_connection((\"db\",5432),3)"'
check "docker compose config is valid" 'docker compose config -q'
echo; echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
