import argparse
from collections import Counter
from contextlib import closing
from html import escape
import os
from pathlib import Path
import pyodbc
import re
import struct
import subprocess
import sys
from string import Template


ROOT = Path(__file__).resolve().parents[1]
SQL_COPT_SS_ACCESS_TOKEN = 1256
SQL_RESOURCE = "https://database.windows.net/"
STATUS_ORDER = {"fail": 0, "error": 0, "warn": 1, "unknown": 2, "skipped": 3, "pass": 4}


def access_token():
    return subprocess.check_output(
        [
            "az", "account", "get-access-token",
            "--resource", SQL_RESOURCE,
            "--query", "accessToken",
            "-o", "tsv"
        ],
        text=True
    ).strip()


def connect():
    token = access_token().encode("utf-16-le")
    token_struct = struct.pack("<I", len(token)) + token
    server = os.getenv("FABRIC_SQL_SERVER", "").strip()
    database = os.getenv("FABRIC_SQL_DATABASE", "").strip()
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        f"Server=tcp:{server},1433;Database={database};"
        "Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    )
    return pyodbc.connect(
        conn_str,
        attrs_before={SQL_COPT_SS_ACCESS_TOKEN: token_struct},
        timeout=30
    )

def fetch_tests(run_id: str) -> list[dict]:
    with closing(connect()) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute(
                """SELECT test_name, test_type, entity, column_name, status,
                          message, invocation_id
                   FROM [log].[test_execution_history]
                   WHERE pipeline_run_id = ?
                   ORDER BY test_name""",
                run_id,
            )
            columns = [column[0] for column in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]


def html_text(value: object, fallback: str = "") -> str:
    return escape(str(value if value is not None and value != "" else fallback), quote=True)


def render_test(test: dict) -> str:
    status = test.get("status") or "unknown"
    search_fields = ("test_name", "test_type", "entity", "column_name", "message")
    search = " ".join(str(test.get(key) or "") for key in search_fields).lower()
    return f'''<article class="test-row" data-status="{html_text(status)}" data-search="{html_text(search)}">
      <div class="test-primary"><span class="dot {html_text(status)}"></span><div class="test-title"><strong>{html_text(test.get('test_name'))}</strong><small>{html_text(test.get('entity'), '—')} <span>·</span> {html_text(test.get('test_type'), 'custom')}</small></div></div>
      <span class="col-name">{html_text(test.get('column_name'), '—')}</span><span class="pill {html_text(status)}">{html_text(status.upper())}</span>
      <details><summary>Details <span aria-hidden="true">⌄</span></summary><div class="detail"><div><b>Message</b><p>{html_text(test.get('message'), 'No additional details available.')}</p></div><div><b>Invocation ID</b><code>{html_text(test.get('invocation_id'), '—')}</code></div></div></details>
    </article>'''


def build_report(tests: list[dict], output: Path, title: str) -> Counter:
    ordered_tests = sorted(
        tests,
        key=lambda test: (
            STATUS_ORDER.get(test.get("status") or "unknown", 4),
            str(test.get("test_name") or ""),
        ),
    )
    counts = Counter(test.get("status") or "unknown" for test in ordered_tests)
    total = len(ordered_tests)
    passed = counts["pass"]
    percentage = 100 * passed / total if total else 0.0
    headline = "NO TESTS FOUND" if not total else (
        "ALL TESTS PASSED" if passed == total else "ISSUES DETECTED"
    )

    template = Template((ROOT / "resources/templates/report.html").read_text(encoding="utf-8"))
    html = template.substitute(
        title=html_text(title),
        stylesheet=(ROOT / "resources/css/report.css").read_text(encoding="utf-8"),
        total=total,
        passed=passed,
        failed=counts["fail"] + counts["error"],
        warnings=counts["warn"],
        headline=headline,
        percent=f"{percentage:.1f}",
        rows="\n".join(render_test(test) for test in ordered_tests),
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(html, encoding="utf-8")
    print(f"HTML report generated: {output} ({total} tests)")
    return counts


def github_summary(
    title: str,
    run_id: str,
    job_status: str,
    counts: Counter,
    error: str = "",
) -> None:

    def safe(value: object) -> str:
        return re.sub(r"[\r\n`|]", " ", str(value))

    lines = [
        f"## {safe(title)}",
        "",
        f"**Fabric run:** `{safe(run_id)}`",
        f"**Job status:** `{safe(job_status)}`",
        "",
    ]

    if error:
        lines.append(f"**Report error:** {safe(error)}")
    else:
        lines.extend([
            f"**Tests:** {sum(counts.values())} · "
            f"**Passed:** {counts['pass']} · "
            f"**Failed / Error:** {counts['fail'] + counts['error']} · "
            f"**Warnings:** {counts['warn']}",
            "",
            "Download the HTML report from this run's artifacts.",
        ])

    content = "\n".join(lines) + "\n"

    if summary_path := os.getenv("GITHUB_STEP_SUMMARY"):
        with open(summary_path, "a", encoding="utf-8") as file:
            file.write(content)

    print(content)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("artifacts/index.html"))
    args = parser.parse_args()

    title = os.getenv("REPORT_TITLE", "CI test results")
    run_id = os.getenv("JOB_INSTANCE_ID", "").strip()
    job_status = os.getenv("JOB_STATUS", "Unknown")
    try:
        tests = fetch_tests(run_id)
        counts = build_report(tests, args.output, title)
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError, pyodbc.Error) as exc:
        print(f"Report generation failed: {exc}", file=sys.stderr)
        github_summary(title, run_id or "Unknown", job_status, Counter(), str(exc))
        return 1

    github_summary(title, run_id, job_status, counts)
    return int(not tests or counts["fail"] > 0 or counts["error"] > 0 or job_status != "Success")


if __name__ == "__main__":
    sys.exit(main())
