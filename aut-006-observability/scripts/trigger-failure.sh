#!/usr/bin/env bash
# Failure scenario: repeated calls to /leak (about 5 MB held per call).
for i in $(seq 1 60); do
  code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5001/leak)
  echo "call $i -> $code"
  [ "$code" = "000" ] && echo "service stopped responding" && break
  sleep 0.3
done
