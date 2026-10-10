# AUT-005: Data Recovery Procedure

## Purpose
Recover the customers database from a SQL backup.

## Prerequisites
- Docker and Docker Compose are installed.
- The project files and `.env` configuration are available.
- A valid, non-empty SQL backup exists outside the repository.
- The backup is accessible and the target database is healthy.

## Backup
1. Start the database with `docker compose up -d`.
2. Record the baseline using `./scripts/baseline.sh`.
3. Create a backup with `./scripts/backup.sh /path/outside/repo/customers.sql`.
4. Protect the backup because it may contain sensitive data.

## Restore
1. Start a clean, isolated PostgreSQL database with a fresh volume.
2. Wait until the target database is healthy.
3. Restore with `psql -v ON_ERROR_STOP=1` using the backup file.
4. Query the row count and checksum.
5. Compare both values with the recorded baseline before accepting recovery.

## Failure handling
The restore script rejects missing or empty files and stops on SQL errors.
An empty-backup rejection was tested. Other corruption scenarios have not been tested.

## Limitations
- Testing used 50 synthetic customer records only.
- Recovery was verified into a fresh PostgreSQL 16 database.
- No production workload, large backup, point-in-time recovery, or automated backup schedule was tested.
- A non-empty file is not necessarily a valid backup; SQL errors can still occur during restore.
- Keep backups outside the repository and restrict access to them.
