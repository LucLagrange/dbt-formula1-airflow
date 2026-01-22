from __future__ import annotations

import os
from datetime import datetime

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

# Host path (real filesystem path on your machine)
HOST_REPO_PATH = os.environ["HOST_REPO_PATH"]

# Container path (inside dbt containers)
REPO_MOUNT = "/workspace"
DBT_DIR = f"{REPO_MOUNT}/dbt"
DUCKDB_PATH = f"{REPO_MOUNT}/warehouse/duckdb/dev.duckdb"

COMMON = dict(
    image="dbt-formula1:local",
    docker_url="unix://var/run/docker.sock",
    network_mode="bridge",
    auto_remove="success",
    mount_tmp_dir=False,
    mounts=[Mount(source=HOST_REPO_PATH, target=REPO_MOUNT, type="bind")],
)

DBT_ENV = {
    "DBT_PROJECT_DIR": DBT_DIR,
    "DBT_PROFILES_DIR": DBT_DIR,
    "DUCKDB_PATH": DUCKDB_PATH,
}

with DAG(
    dag_id="f1__docker__dbt_staging",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["f1", "dbt", "airflow3", "docker"],
) as dag:
    ingest_raw = DockerOperator(
        task_id="ingest_raw",
        command="python orchestration/scripts/ingest_raw.py",
        working_dir=REPO_MOUNT,
        **COMMON,
    )

    dbt_deps = DockerOperator(
        task_id="dbt_deps",
        command="dbt deps",
        working_dir=DBT_DIR,
        environment=DBT_ENV,
        **COMMON,
    )

    dbt_build_staging = DockerOperator(
        task_id="dbt_build_staging",
        command="dbt build --select path:models/staging",
        working_dir=DBT_DIR,
        environment=DBT_ENV,
        **COMMON,
    )

    ingest_raw >> dbt_deps >> dbt_build_staging
