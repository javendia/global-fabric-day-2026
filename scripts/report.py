from collections import Counter
import os
import pyodbc
import struct
import subprocess
import sys

SQL_COPT_SS_ACCESS_TOKEN = 1256
JOB_INSTANCE_ID = os.environ.get("JOB_INSTANCE_ID")
JOB_STATUS = os.environ.get("JOB_STATUS")
SERVER = os.environ["FABRIC_SQL_SERVER"]
DATABASE = os.environ["FABRIC_SQL_DATABASE"]
SUMMARY_PATH = os.getenv("GITHUB_STEP_SUMMARY")
TITLE = os.getenv("REPORT_TITLE", "CI test results")

def access_token():
    return subprocess.check_output(
        [
            "az", "account", "get-access-token",
            "--resource", "https://database.windows.net/",
            "--query", "accessToken",
            "-o", "tsv"
        ],
        text=True
    ).strip()

def connect():
    token = access_token().encode("utf-16-le")
    token_struct = struct.pack("<I", len(token)) + token
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        f"Server=tcp:{SERVER},1433;Database={DATABASE};"
        "Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    )
    return pyodbc.connect(
        conn_str,
        attrs_before={SQL_COPT_SS_ACCESS_TOKEN: token_struct},
        timeout=30
    )

def esc(value):
    return str(value or "").replace("|", r"\|").replace("\r", " ").replace("\n", " ")

def prepare_report():

    try:
        cn = connect()
        cur = cn.cursor()
        cur.execute(
            """
            SELECT 
                [test_name],
                [test_type],
                [entity],
                [column_name],
                [status]
            FROM [log].[test_execution_history]
            WHERE [pipeline_run_id] = ?
            """
            , JOB_INSTANCE_ID
        )
        rows = cur.fetchall()
        cn.close()

    except Exception as e:
        md = (
            f"## {TITLE}\n\nCould not retrieve test details from Fabric Warehouse.\n\n"
            f"Pipeline status: `{JOB_STATUS}`\n\nError: `{esc(e)}`\n"
        )
        if SUMMARY_PATH:
            with open(SUMMARY_PATH, "a", encoding="utf-8") as f:
                f.write(md)
        print(md, file=sys.stderr)
        return 1

    if not rows:
        md = (
            f"## {TITLE}\n\nNo rows found in `log.test_execution_history` for the current pipeline run.\n\n"
            f"Pipeline status: `{JOB_STATUS}`.\n"
        )
        if SUMMARY_PATH:
            with open(SUMMARY_PATH, "a", encoding="utf-8") as f:
                f.write(md)
        print(md)
        return 1

    counts = Counter(str(r.status).lower() for r in rows)
    failed = counts.get("fail", 0) + counts.get("error", 0)

    lines = [
        f"## {TITLE}", "",
        f"**Job status:** `{JOB_STATUS}`",
        f"**Tests captured:** {len(rows)}",
        "",
        "| Result | Count |", "|---|---:|",
        f"| Passed | {counts.get('pass', 0)} |",
        f"| Failed / Error | {counts.get('fail', 0) + counts.get('error', 0)} |",
        f"| Warn | {counts.get('warn', 0)} |",
        f"| Skipped | {counts.get('skipped', 0)} |", ""
    ]

    lines += ["### All captured tests", "", "| Test | Test type | Entity | Status | Column |", "|---|---|---|---|---|"]
    for r in rows:
        lines.append(
            f"| `{esc(r.test_name)}` | {esc(r.test_type)} | {esc(r.entity)} | {esc(r.status)} | {esc(r.column_name)} |"
        )

    md = "\n".join(lines)
    if SUMMARY_PATH:
        with open(SUMMARY_PATH, "a", encoding="utf-8") as f:
            f.write(md)
    print(md)

    if JOB_STATUS != "Success":
        return 1

    return 1 if failed > 0 else 0

if __name__ == "__main__":
    sys.exit(prepare_report())