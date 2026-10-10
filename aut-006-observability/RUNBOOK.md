# AUT-006: Observability and Incident Runbook

## 1. Detection

Indicators of a memory incident:
- Memory usage increases continuously.
- Requests begin failing or the service stops responding.
- Docker reports the container exited with code 137 and `OOMKilled=true`.
- Logs show repeated `simulated_memory_leak` events.

## 2. Diagnosis

Check container status:

`docker compose ps -a`

Inspect the exit status:

`docker inspect "$(docker compose ps -aq app)" --format 'State={{.State.Status}} ExitCode={{.State.ExitCode}} OOMKilled={{.State.OOMKilled}}'`

Expected incident result: `ExitCode=137 OOMKilled=true`.

Inspect application logs:

`docker compose logs --tail=100 app`

Look for repeated JSON `simulated_memory_leak` events and increasing `held_mb` values.

Check resource usage:

`docker stats --no-stream`

Note: stopped containers may not appear in `docker stats`. Use `docker inspect` and saved logs for stopped-container diagnosis.

## 3. Root Cause

The `/leak` handler appended a new 5 MB string to a global list on every request. Because the list retained references to the strings, memory usage continued growing.

During the local test, 48 requests returned HTTP 200; request 49 returned HTTP 000. The container exited with code 137 and `OOMKilled=true`. The final logged retained-memory counter reached 240 MB.

## 4. Remediation and Mitigation

- Disable the faulty endpoint and remove the unbounded allocation.
- Keep the container memory limit at 128 MiB as a resource safeguard, not as the primary fix.
- Keep the CPU limit at 0.5 CPU.
- Restart the service after applying the fix and verify health.
- Do not repeatedly restart a leaking service without addressing its root cause.

The memory limit can constrain resource consumption and lead to a container being killed when memory is exhausted. It does not fix the leak and can cause service downtime. A health check detects health-endpoint failures but does not prevent memory growth.

## 5. Post-Fix Verification

- Rebuild and start the container.
- Confirm the container becomes healthy.
- Confirm `/health` returns HTTP 200.
- Confirm normal `/work` requests return HTTP 200.
- Confirm `/leak` is disabled and returns HTTP 410 without allocating retained memory.
- Inspect logs to ensure no secret values are printed.
- Check `docker stats --no-stream` to verify memory remains stable during repeated requests.

## 6. Evidence and Limitations

Incident logs and container state were captured under `~/devops-backups/aut-006/`.

Testing was performed locally using dummy configuration. The incident was a deliberately simulated memory leak, not a production outage. The memory and CPU limits are training settings and require workload-specific sizing in real deployments.