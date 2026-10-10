#!/usr/bin/env bash
# Normal traffic: 20 requests to /work.
for i in $(seq 1 20); do curl -s -o /dev/null -w "%{http_code} " http://localhost:5001/work; done; echo
