# AUT-005: Data Persistence, Backup, and Restore

A Postgres container holding 50 synthetic customer records. The team reports that **data disappears when the container is recreated**.

## Setup
```bash
cp .env.example .env
docker compose up -d
./scripts/seed.sh        # loads 50 rows
./scripts/baseline.sh    # prints row count + checksum
```

## Provided
- `docker-compose.yml`: the current (faulty) setup
- `seed.sql`: synthetic data
- `scripts/check-persistence.sh`: seeds, recreates the container, compares before/after

## Your job
1. Run `./scripts/check-persistence.sh` and record the failure.
2. Find the configuration problem and fix it so the data survives `docker compose down` followed by `docker compose up`.
3. Write `scripts/backup.sh` and `scripts/restore.sh`.
4. Restore into a **clean** environment (fresh volume) and compare row count and checksum with your baseline.
5. Test one failure case (for example, a corrupted or empty backup file) and show how your procedure detects it.
6. Write a short recovery procedure with prerequisites and limitations. Only claim what you tested.

Use synthetic data only. Do not store backups in the repository.
