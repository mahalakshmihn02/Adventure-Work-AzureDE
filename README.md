# AdventureWorks – End-to-End Azure Data Engineering Project

## Project Overview

This project demonstrates an end-to-end Azure Data Engineering pipeline using the AdventureWorks dataset.

The solution implements a Medallion Architecture with Bronze, Silver and Gold layers. Data is ingested from GitHub using Azure Data Factory, transformed using Azure Databricks and PySpark, served through Azure Synapse Analytics and finally visualized using Power BI.

The project focuses on dynamic ingestion, parameterized pipelines, cloud storage, PySpark transformations, secure Azure authentication and SQL-based data serving.

## Architecture

```text
AdventureWorks CSV Files
          |
          v
      GitHub / HTTP
          |
          v
+----------------------+
| Azure Data Factory   |
|                      |
| Lookup               |
| ForEach              |
| Parameterized Copy   |
+----------+-----------+
           |
           v
+----------------------+
| ADLS Gen2 - BRONZE   |
| Raw CSV Data         |
+----------+-----------+
           |
           v
+----------------------+
| Azure Databricks     |
| PySpark              |
| Cleaning             |
| Transformation       |
+----------+-----------+
           |
           v
+----------------------+
| ADLS Gen2 - SILVER   |
| Transformed Parquet  |
+----------+-----------+
           |
           v
+----------------------+
| Azure Synapse        |
| Serverless SQL       |
| OPENROWSET           |
| Views                |
| External Tables      |
+----------+-----------+
           |
           v
+----------------------+
| GOLD / Serving Layer |
+----------+-----------+
           |
           v
       Power BI
```

## Technologies Used

* Azure Data Factory
* Azure Data Lake Storage Gen2
* Azure Databricks
* PySpark
* Azure Synapse Analytics
* Serverless SQL
* Microsoft Entra ID
* Managed Identity
* RBAC
* Parquet
* SQL
* Power BI
* GitHub

## Dataset

The project uses the AdventureWorks dataset containing information related to:

* Calendar
* Customers
* Products
* Product Categories
* Product Subcategories
* Sales
* Returns
* Territories

The source CSV files are available in the `data` section of this repository.

## Bronze Layer – Data Ingestion

Azure Data Factory is used as the orchestration layer.

A metadata-driven JSON configuration is used to define:

* Source relative URL
* Destination folder
* Destination file name

ADF uses:

1. Lookup Activity
2. ForEach Activity
3. Parameterized Copy Activity

The Lookup activity reads the metadata configuration and passes the resulting array to the ForEach activity.

The Copy Activity dynamically retrieves the source files and stores them in the Bronze container of ADLS Gen2.

### Key concepts demonstrated

* Dynamic pipelines
* Parameterized datasets
* Lookup Activity
* ForEach Activity
* Copy Activity
* Metadata-driven ingestion
* REST/HTTP-based source ingestion

## Silver Layer – Data Transformation

Azure Databricks is used for transformation.

PySpark reads the raw data from the Bronze layer and performs data preparation and transformation before writing the results to the Silver layer in Parquet format.

Typical transformation activities include:

* Reading CSV data
* Schema/data type handling
* Null handling
* Duplicate handling
* Column transformations
* Data cleansing
* Writing transformed data as Parquet

## Security and Authentication

The project uses Azure identity-based access for communication between Azure services.

Microsoft Entra ID App Registration is used for external application authentication where required.

Azure RBAC is configured using appropriate roles such as Storage Blob Data Contributor.

Azure Managed Identity is used for Azure service-to-service access where applicable.

No credentials or secrets are stored in this repository.

## Gold Layer – Azure Synapse Analytics

Azure Synapse Analytics Serverless SQL is used as the serving/query layer.

The Silver Parquet files are queried using `OPENROWSET`.

Example:

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage-account>.blob.core.windows.net/silver/<folder>/',
    FORMAT = 'PARQUET'
) AS Query1;
```

A Gold schema is created and views are defined for the business entities.

Views include:

* `gold.calendar`
* `gold.customer`
* `gold.productcategories`
* `gold.productsubcategories`
* `gold.territories`
* `gold.products`
* `gold.returns`
* `gold.sales`

External data sources and external file formats are then configured, followed by external tables for serving the curated data.

## Power BI

Power BI is connected to the Synapse serving layer to create analytical dashboards.

The dashboard contains visualizations such as:

* Sales trends
* Product performance
* Customer analysis
* Territory analysis
* Return analysis
* KPI cards
* Bar charts
* Line charts

## Key Data Engineering Concepts Demonstrated

### Data Ingestion

GitHub → Azure Data Factory → ADLS Bronze

### Data Transformation

ADLS Bronze → Databricks/PySpark → ADLS Silver

### Data Serving

ADLS Silver → Synapse Serverless SQL → Gold

### Analytics

Synapse → Power BI

## Repository Structure

```text
adf/
    pipelines/
    datasets/
    linked-services/

databricks/
    bronze_to_silver.py

synapse/
    views/
    external_tables/
    database_setup.sql

powerbi/
    dashboard.png

architecture/
    architecture.png

screenshots/
    adf_pipeline.png
    databricks_notebook.png
    synapse.png
    powerbi_dashboard.png

docs/
    project_flow.md
    data_dictionary.md
```

## Learning Outcome

Through this project, I gained hands-on experience in designing and implementing an end-to-end Azure Data Engineering pipeline involving data ingestion, cloud storage, transformation, data serving, security and visualization.

The project helped me understand how different Azure services work together in a modern data platform.

## Disclaimer

This project was implemented as a hands-on learning project based on publicly available learning material. The implementation, documentation and repository organization are maintained for educational and portfolio purposes.
