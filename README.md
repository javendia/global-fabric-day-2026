# Global Fabric Day 2026 (FUGE) - Online

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Microsoft Fabric](https://img.shields.io/badge/Microsoft-Fabric-blue)](https://www.microsoft.com/microsoft-fabric)
[![dbt](https://img.shields.io/badge/dbt-Data%20Build%20Tool-orange)](https://www.getdbt.com/)

Demo repository for the talks **"SQL + dbt + Microsoft Fabric: A Modern Approach to Data Warehouse Development"** and **"All I Want for Christmas Is... Green Tests!"**

---

## Overview

The full demo shows how to turn raw data into a dimensional model using dbt in Microsoft Fabric. Also, it shows how to validate those entities with dbt tests and report the results in GitHub Actions.

1. A Fabric data pipeline runs a dbt job that reads from the source Lakehouse, builds the Warehouse models, and runs their data quality tests.
2. A dbt end-of-run hook stores the test results in the Warehouse. The Fabric pipeline links those results to the pipeline run that produced them.
3. The GitHub Action retrieves the results for that run, and publishes an HTML report as a workflow artifact.

---

## Repository contents

- [`src/`](./src): Fabric item definitions for the source Lakehouse, dbt job and project, orchestration pipeline, and curated Warehouse.
- [`.github/workflows/`](./.github/workflows): GitHub Actions workflow for running the tests and publishing the report.
- [`scripts/`](./scripts): Python script that reads test results from the Warehouse and generates the HTML report.
- [`resources/`](./resources): report [template](./resources/templates), [stylesheet](./resources/css), and [sample HTML report](./resources/html/sample_report.html).
- [`DEPLOYMENT.md`](./DEPLOYMENT.md): CI documentation.

---

## Prerequisites

- An active **Microsoft Fabric capacity** and a workspace assigned to it, and a service principal with  at least the **Contributor** role in that workspace.
- Access to the [AdventureWorksLT sample data](https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks).

---

## Getting started

1. Fork this repository and use Fabric Git integration to sync your workspace with [`src/`](./src) in your fork.
2. Make the AdventureWorksLT source tables available in the `SalesLT` schema of the source Lakehouse. The checked-in item definitions do not load the sample data.
3. Configure the dbt job and pipeline connections for your workspace. Follow the [CI guide](./DEPLOYMENT.md) to set up the Fabric variable library and the GitHub Actions `test` environment.
4. In GitHub, select **Actions > Deploy > Run workflow**. When the report is generated, download it from the workflow run's artifacts.

---

## License

This project is licensed under the [MIT License](./LICENSE).
