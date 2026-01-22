from __future__ import annotations

import os
from datetime import datetime

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

from cosmos import (
    DbtTaskGroup,
    ProjectConfig,
    ProfileConfig,
    ExecutionConfig,
    RenderConfig,
)
from cosmos.constants import ExecutionMode, LoadMode

HOST_REPO_PATH = os.environ["HOST_REPO_PATH"]

REPO_MOUNT = "/workspace"
DBT_DIR = f"{REPO_MOUNT}/dbt"
DUCKDB_PATH = f"{REPO_MOUNT}/warehouse/duckdb/dev.duckdb"

COMMON_MOUNTS = [Mount(source=HOST_REPO_PATH, target=REPO_MOUNT, type="bind")]

DBT_ENV = {
    "DBT_PROJECT_DIR": DBT_DIR,
    "DBT_PROFILES_DIR": DBT_DIR,
    "DUCKDB_PATH": DUCKDB_PATH,
    "DBT_THREADS": "1",
}

with DAG(
    dag_id="f1__cosmos__staging_from_manifest",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    max_active_tasks=1,
    max_active_runs=1,
    tags=["f1", "dbt", "airflow3", "cosmos"],
) as dag:
    ingest_raw = DockerOperator(
        task_id="ingest_raw",
        image="dbt-formula1:local",
        command="python orchestration/scripts/ingest_raw.py",
        working_dir=REPO_MOUNT,
        docker_url="unix://var/run/docker.sock",
        network_mode="bridge",
        auto_remove="success",
        mount_tmp_dir=False,
        mounts=COMMON_MOUNTS,
        environment=DBT_ENV,
    )

    # Ensure manifest exists/updated (Cosmos will read it)
    dbt_parse = DockerOperator(
        task_id="dbt_parse",
        image="dbt-formula1:local",
        command="dbt parse",
        working_dir=DBT_DIR,
        docker_url="unix://var/run/docker.sock",
        network_mode="bridge",
        auto_remove="success",
        mount_tmp_dir=False,
        mounts=COMMON_MOUNTS,
        environment=DBT_ENV,
    )

    profile_config = ProfileConfig(
        profile_name="dbt_formula1_airflow",
        target_name="dev",
        profiles_yml_filepath=f"{DBT_DIR}/profiles.yml",
    )

    project_config = ProjectConfig(
        dbt_project_path=DBT_DIR,
        manifest_path=f"{DBT_DIR}/target/manifest.json",
        install_dbt_deps=False,
    )

    render_config = RenderConfig(
        load_method=LoadMode.DBT_MANIFEST,
        select=["path:models/staging"],
        # KEY: one Airflow task per dbt node (no bundling inside the task group)
        node_conversion_by_task_group=False,
    )

    execution_config = ExecutionConfig(
        execution_mode=ExecutionMode.DOCKER,
    )

    dbt_staging = DbtTaskGroup(
        group_id="dbt_staging",
        project_config=project_config,
        profile_config=profile_config,
        render_config=render_config,
        execution_config=execution_config,
        operator_args={
            "image": "dbt-formula1:local",
            "docker_url": "unix://var/run/docker.sock",
            "network_mode": "bridge",
            "auto_remove": "success",
            "mount_tmp_dir": False,
            "mounts": COMMON_MOUNTS,
            "working_dir": DBT_DIR,
            "environment": DBT_ENV,
        },
    )

    ingest_raw >> dbt_parse >> dbt_staging
