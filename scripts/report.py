import os
import pyodbc
import struct
import subprocess
import sys

SQL_COPT_SS_ACCESS_TOKEN = 1256

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
    server = os.environ["FABRIC_SQL_SERVER"]
    database = os.environ["FABRIC_SQL_DATABASE"]
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

def main():
    conn = connect()

if __name__ == "__main__":
    sys.exit(main())