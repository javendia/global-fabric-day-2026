# Continuous integration with dbt and Microsoft Fabric

This guide describes how the demo runs dbt tests in Microsoft Fabric, stores the results and publishes an HTML report in GitHub Actions.

---

## Testing process

1. A manually triggered GitHub Actions workflow runs the Fabric orchestration pipeline.
2. The pipeline invokes the dbt job with the `build` operation, which builds models and runs their tests.
3. At the end of the dbt run, an `on-run-end` macro persists test results in the Warehouse.
4. After the dbt activity completes, the pipeline reads the dbt log to obtain the invocation ID and associates its test records with the Fabric pipeline run ID.
5. GitHub Actions uses that pipeline run ID to retrieve the results and generate an HTML report, which is uploaded as a workflow artifact.

See the [main README](README.md) for the initial workspace setup.

---

## Configuration and execution

### Microsoft Fabric

Configure the Fabric pipeline using the `vl_variables` variable library:

| Variable | Purpose |
|---|---|
| `client_id` | Azure client ID |
| `client_secret` | Azure client secret |
| `dbt_job_name` | dbt job name |
| `scope` |https://storage.azure.com/.default |
| `tenant_id` | Azure tenant ID |
| `workspace_name` | Fabric workspace name |

The Warehouse must contain the test history table and be accessible to the identities running the dbt job, updating the history and generating the report.

### GitHub Actions

Configure the `test` environment in GitHub Actions. Grant the service principal access to the Fabric workspace and Warehouse. Azure login uses OpenID Connect, so the service principal needs a federated identity credential for the GitHub environment.

| Name | Type | Purpose |
|---|---|---|
| `FABRIC_CLIENT_ID` | Secret | Service principal client ID |
| `FABRIC_CLIENT_SECRET` | Secret | Exposed to the Fabric CLI environment |
| `FABRIC_JOB_TIMEOUT` | Variable | Fabric job timeout |
| `FABRIC_ORCHESTRATOR` | Variable | Fabric orchestration pipeline name |
| `FABRIC_SQL_DATABASE` | Variable | Warehouse database for the report |
| `FABRIC_SQL_SERVER` | Variable | Warehouse SQL endpoint for the report |
| `FABRIC_TENANT_ID` | Secret | Azure tenant ID |
| `FABRIC_WORKSPACE` | Variable | Fabric workspace name |

To run the process, open **Actions → Deploy → Run workflow** in GitHub. The workflow installs its dependencies, authenticates to Azure, and waits for the Fabric pipeline to complete.

---

## Results and report

Test results are stored in the Warehouse table `log.test_execution_history` with the following structure:

| Field | Description |
|---|---|
| `column_name` | Tested column, when applicable |
| `entity` | Entity associated with the test |
| `execution_datetime` | Time the result was recorded |
| `invocation_id` | dbt invocation identifier |
| `message` | Additional result details |
| `pipeline_run_id` | Fabric pipeline run used to select results for the report |
| `status` | Test outcome |
| `test_name` | Name of the test |
| `test_type` | Type of test |

The report selects records by `pipeline_run_id`, groups test outcomes and displays searchable, filterable details. `execution_datetime` is stored in the Warehouse but is not included in the report. The report is a self-contained HTML file with embedded CSS.

See the [sample HTML report](resources/html/sample_report.html) for an example.

When a Fabric pipeline run ID is available, GitHub Actions attempts to generate and upload the report even if the pipeline step fails. The artifact is retained for 30 days. The report step fails if there are no tests, any test has a failure or error status, or the reported Fabric job status is not `Success`; warnings alone do not fail it.
