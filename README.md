# dbt + DuckDB + Airflow (Cosmos) — Formula 1 Project

This repository is a local analytics “data app” built around **dbt + DuckDB** for transformation and a lightweight **Airflow orchestration layer**. Today the project contains the **staging layer** and a working end‑to‑end pipeline. The next steps are to add marts and (optionally) a BI layer.

## What’s in here (today)

The project currently implements:

- **Raw ingestion**: CSVs are loaded into DuckDB `raw.*` tables.
- **dbt staging models**: dbt models in `dbt/models/staging` build the staging layer and run tests.
- **Airflow orchestration**: Airflow runs the pipeline inside Docker, using a dedicated **dbt runtime image**.
- **Cosmos integration**: Cosmos can **render the dbt graph from existing dbt artifacts** (`manifest.json`) and execute dbt nodes via Docker.

---

## Repository structure

```text
dbt/                     # dbt project (models, profiles.yml, etc.)
warehouse/
  external/              # raw CSV inputs (source data)
  duckdb/                # DuckDB file(s), e.g. dev.duckdb
orchestration/
  dags/                  # Airflow DAGs
  scripts/               # ingestion scripts (e.g. ingest_raw.py)
  docker-compose.yaml
  Dockerfile.airflow
  Dockerfile.dbt
  requirements.airflow.txt
  .env                   # HOST_REPO_PATH, etc.
pyproject.toml / uv.lock # local dev environment managed by uv
```

---

## Architecture (how it works)

### DuckDB “warehouse”
DuckDB is file-based: the “warehouse” is a single file:

- `warehouse/duckdb/dev.duckdb`

Both local runs and Airflow runs can point to the same file as long as they use consistent paths.

### Concurrency and locks (important)
DuckDB uses file locks. If multiple tasks/containers open the same `.duckdb` file concurrently, you can hit errors like:

- `Could not set lock on file ... Conflicting lock ...`

For this reason the Cosmos DAG is configured (or should be configured) with:

- `max_active_tasks=1`
- `max_active_runs=1`
- `DBT_THREADS=1`

This forces sequential execution and avoids lock issues.

---

## Prerequisites

- Docker + Docker Compose (Docker Desktop or Linux Docker)
- `uv` (for local dbt runs; optional if you only use Airflow/Docker)
- A working `.env` file in `orchestration/` with your host repo path

Example:

```text
HOST_REPO_PATH=/home/<you>/path/to/dbt-formula1-airflow
```

---

## Local development (uv)

### Install dependencies
From repo root:

```bash
uv sync
```

### Ingest raw data locally
```bash
uv run python orchestration/scripts/ingest_raw.py
```

### Run dbt locally
```bash
DBT_PROJECT_DIR=dbt DBT_PROFILES_DIR=dbt uv run dbt build
```

The dbt profile uses:

- `DUCKDB_PATH` env var if set
- otherwise defaults to `warehouse/duckdb/dev.duckdb`

---

## Orchestration (Airflow + Docker)

### 1) Build and start Airflow
From `orchestration/`:

```bash
docker compose up --build
```

Airflow runs in “standalone” mode for local development. The UI is typically at:

- http://localhost:8080

Credentials:
- username: `admin`
- password: printed in the Airflow container logs (look for “Password for user 'admin': …”)

### 2) Run the DAG
Trigger the DAG in the Airflow UI.

There are typically tasks like:
- `ingest_raw` (loads CSVs into `raw.*`)
- `dbt_parse` (produces dbt artifacts, including `manifest.json`)
- `dbt_staging` (Cosmos group, node-by-node dbt execution)

---

## Cosmos: what it’s doing here

Cosmos is used to:

1) **Render the dbt graph from an existing `manifest.json`**
2) Turn dbt nodes (models/tests) into Airflow tasks

In this repo, Cosmos is configured to use:

- `load_method = DBT_MANIFEST` (renders from artifacts)
- `execution_mode = DOCKER` (runs dbt commands inside the dbt image)
- bind mounts + env vars so dbt containers can see:
  - the repo at `/workspace`
  - the DuckDB file at `/workspace/warehouse/duckdb/dev.duckdb`

---

## Roadmap / future expansion

### 1) Add marts
Add a `dbt/models/marts` layer (facts/dimensions) and create a second DAG (or expand Cosmos selection) to run:

- staging → marts

### 2) Add scheduling
Add a `schedule` (cron) to the DAG(s) and use Airflow retries/alerting.

### 3) Add BI (Superset or similar)

---

## Notes
This project is currently optimized for local development and learning. Airflow “standalone” and a file-based DuckDB warehouse are not meant for production without additional hardening.