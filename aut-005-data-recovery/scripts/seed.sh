#!/usr/bin/env bash
# Loads the 50 synthetic customer rows.
. "$(dirname "$0")/common.sh"
wait_for_db && psql_db < seed.sql
