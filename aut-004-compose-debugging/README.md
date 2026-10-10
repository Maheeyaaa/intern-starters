# AUT-004: Broken Multi-Service Compose Environment

A small web, API, and database stack that someone has left in a broken state.

## Architecture (must be preserved)
- `web`: Nginx reverse proxy, published on host port **8080**
- `api`: Flask API (listens on 5000 inside its container)
- `db`: Postgres with a few sample rows
- Three Docker networks: `frontend`, `backend`, `data`. Keep the architecture; fix the configuration.

## Setup
```bash
cp .env.example .env
docker compose up -d --build
```

## Reported symptoms
- Nothing answers on `http://localhost:8080`.
- Once something answers, requests fail with an error page instead of data.
- One service never becomes healthy and the services that depend on it do not start.
- `/items` returns an error instead of the sample records.
- The API logs show it cannot talk to the database.

There may be more than one cause behind each symptom.

## Your job
1. Reproduce each failure **before** changing any file. Save the output.
2. Find the root cause of each failure and write it down before you fix it.
3. Fix the configuration. Do not change the service architecture or remove the health check.
4. Run `./verify.sh` until every check passes.

Deliver the corrected files, a root-cause table (symptom, cause, fix, verification), and the before/after output.
