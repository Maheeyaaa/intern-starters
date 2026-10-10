# DevOps Intern Task Pack

A collection of hands-on DevOps exercises focused on containerized environments, data recovery, observability, and incident diagnosis. Each task is maintained in its own directory and uses local Docker-based testing with dummy data and credentials.

## Tasks

### AUT-004: Fix a Broken Multi-Service Environment

**Focus:** Docker Compose, service networking, environment configuration, and health checks.

- Diagnosed and fixed issues in a multi-service application environment.
- Verified communication between services and application availability.
- Validated the environment using the provided verification script.

**Directory:** [`aut-004-compose-debugging/`](aut-004-compose-debugging/)

### AUT-005: Data Persistence, Backup, and Restore

**Focus:** Docker volumes, database persistence, backup, and recovery validation.

- Configured persistent storage for database data.
- Implemented and tested backup and restore workflows.
- Verified data recovery by comparing restored data with the original dataset.
- Tested handling of invalid or empty backups.

**Directory:** [`aut-005-data-recovery/`](aut-005-data-recovery/)

### AUT-006: Observability and Incident Diagnosis

**Focus:** Structured logging, health checks, resource limits, and incident response.

- Implemented structured JSON application logging.
- Added a health endpoint and Docker CPU and memory limits.
- Reproduced a memory-leak incident and investigated the resulting container failure.
- Disabled the faulty endpoint and verified the mitigation.
- Documented incident detection, diagnosis, remediation, and verification in a runbook.

**Directory:** [`aut-006-observability/`](aut-006-observability/)

## Technologies and Tools

- Docker and Docker Compose
- Linux/Unix command-line tools
- Bash scripting
- Python and Flask
- HTTP health checks and `curl`
- Container logs, resource monitoring, and incident diagnosis
- Data persistence, backup, and restore workflows

## Repository Structure

```text
devops-intern-starters/
├── README.md
├── .gitignore
├── aut-004-compose-debugging/
├── aut-005-data-recovery/
└── aut-006-observability/
    ├── README.md
    ├── RUNBOOK.md
    ├── app/
    ├── scripts/
    └── docker-compose.yml
```

Each task directory contains its own configuration, scripts, and task-specific documentation.

## Safety and Scope

- All scenarios are intended for local training and testing.
- Use dummy data and credentials only.
- Never commit `.env` files, real credentials, or sensitive information.
- Do not run these scenarios against production systems.

## Verification

Each task should be validated using its provided scripts and documented verification steps. AUT-006 includes a documented memory-incident simulation and post-mitigation checks.

See each task's README for setup instructions and task-specific details.