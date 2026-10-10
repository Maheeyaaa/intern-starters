# AUT-006: Observability and Incident Diagnosis

A Flask API used to practice structured logging, health checks, resource limits, and incident diagnosis.

## Endpoints

- `/` — service status
- `/work` — normal request simulation
- `/health` — health check
- `/leak` — disabled after the simulated memory incident; returns HTTP 410

## Setup

```bash
cp .env.example .env
docker compose up -d --build
```

Set only dummy values in `.env`.

## Normal Behavior

Run the normal workload:

```bash
./scripts/normal-load.sh
docker compose ps
docker stats --no-stream
docker compose logs app
```

Expected results:
- Normal requests return HTTP 200.
- The container becomes healthy.
- Application events use structured JSON logs with timestamps, levels, and event names.
- Sensitive values are not printed in application logs.

## Failure Simulation

Run the provided failure scenario:

```bash
./scripts/trigger-failure.sh
```

The original `/leak` handler retained a new 5 MB string on every request. During testing, memory usage grew until the container was OOM-killed. The incident produced exit code 137 and `OOMKilled=true`.

Incident evidence is saved under `~/devops-backups/aut-006/`.

## Resource Controls

The Compose configuration sets:
- Memory limit: 128 MiB
- CPU limit: 0.5 CPU
- Health check: requests `/health` inside the container

Resource limits constrain resource consumption but do not fix application bugs. A memory limit may cause the container to be killed when it reaches the limit. A health check detects health-endpoint failures but does not prevent memory leaks.

## Mitigation and Verification

The `/leak` endpoint is disabled and returns HTTP 410 without retaining additional memory.

Verify the fix:

```bash
curl -i http://localhost:5001/health
curl -i http://localhost:5001/leak
./scripts/normal-load.sh
docker compose ps
docker stats --no-stream
docker compose logs app
```

Expected results:
- `/health` returns HTTP 200.
- `/leak` returns HTTP 410.
- Normal requests return HTTP 200.
- The container remains healthy and memory remains stable during normal requests.

## Incident Runbook

See [RUNBOOK.md](RUNBOOK.md) for detection, diagnosis commands, root cause, remediation, and post-fix verification.