from __future__ import annotations

import glob
from pathlib import Path

import duckdb

REPO_ROOT = Path(__file__).resolve().parents[2]
DUCKDB_PATH = REPO_ROOT / "warehouse" / "duckdb" / "dev.duckdb"
EXTERNAL_DIR = REPO_ROOT / "warehouse" / "external"


def main() -> None:
    csv_paths = sorted(Path(p) for p in glob.glob(str(EXTERNAL_DIR / "*.csv")))
    if not csv_paths:
        raise SystemExit(f"No CSV files found in: {EXTERNAL_DIR}")

    DUCKDB_PATH.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(DUCKDB_PATH))
    con.execute("create schema if not exists raw;")

    for csv_path in csv_paths:
        table = csv_path.stem.lower()
        print(f"Loading {csv_path.name} -> raw.{table}")

        con.execute(f'drop table if exists raw."{table}";')
        con.execute(
            f"""
            create table raw."{table}" as
            select *
            from read_csv_auto(
              '{csv_path.as_posix()}',
              header=true,
              sample_size=-1
            );
            """
        )

    print("Raw tables:", con.execute("show tables from raw").fetchall())
    con.close()


if __name__ == "__main__":
    main()
