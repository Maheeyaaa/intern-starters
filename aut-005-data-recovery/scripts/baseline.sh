#!/usr/bin/env bash
# Prints the row count and a checksum of the customers table.
. "$(dirname "$0")/common.sh"
psql_db -At -c "SELECT count(*) || ' rows, checksum ' || md5(string_agg(id::text || name || email || score::text, ',' ORDER BY id)) FROM customers;"
