# 🏗️ AdventureWorks Azure Data Engineering – Architecture

## 📌 Overview

This folder contains the architecture and overall data flow of the AdventureWorks Azure Data Engineering project.

The project follows a **Medallion Architecture** with three main layers:

* 🥉 Bronze – Raw data
* 🥈 Silver – Cleaned and transformed data
* 🥇 Gold – Business/serving layer

The complete pipeline uses Azure Data Factory, Azure Data Lake Storage Gen2, Azure Databricks, PySpark, Azure Synapse Analytics and Power BI.

---

# 🔄 End-to-End Architecture

```text
                    AdventureWorks Dataset
                            |
                            v
                     GitHub Repository
                            |
                            | HTTP
                            v
                +-------------------------+
                |    Azure Data Factory   |
                |                         |
                | Lookup                  |
                | ForEach                 |
                | Dynamic Copy            |
                +------------+------------+
                             |
                             v
                +-------------------------+
                |     ADLS Gen2           |
                |      BRONZE             |
                |                         |
                |      Raw CSV Files      |
                +------------+------------+
                             |
                             v
                +-------------------------+
                |    Azure Databricks     |
                |                         |
                |       PySpark           |
                |                         |
                | Cleaning                |
                | Null Handling           |
                | Duplicate Handling      |
                | Transformations         |
                +------------+------------+
                             |
                             v
                +-------------------------+
                |     ADLS Gen2           |
                |       SILVER            |
                |                         |
                |   Transformed Parquet   |
                +------------+------------+
                             |
                             v
                +-------------------------+
                |   Azure Synapse         |
                |   Serverless SQL        |
                |                         |
                |   OPENROWSET            |
                |   Views                 |
                |   External Tables       |
                +------------+------------+
                             |
                             v
                +-------------------------+
                |      GOLD / SERVING     |
                +------------+------------+
                             |
                             v
                         Power BI
                             |
                             v
                         Dashboard
```

---

# 🥉 Bronze Layer

The Bronze layer contains the raw data ingested from GitHub.

### Source

```text
GitHub
```

### Ingestion Tool

```text
Azure Data Factory
```

### Storage

```text
Azure Data Lake Storage Gen2
```

### Data Format

```text
CSV
```

The objective of the Bronze layer is to preserve the source data in its raw form before transformation.

---

# 🥈 Silver Layer

The Silver layer contains cleaned and transformed data.

Azure Databricks is used to process the Bronze data.

### Technology

```text
Azure Databricks
PySpark
```

### Main Activities

* Read CSV files
* Check schema
* Handle data types
* Check null values
* Check duplicate records
* Remove duplicates where required
* Perform data cleansing
* Create transformed DataFrames
* Write the output in Parquet format

---

# 🥇 Gold / Serving Layer

Azure Synapse Analytics is used as the serving layer.

The Silver Parquet files are queried using **Serverless SQL**.

The project creates views under the `gold` schema.

Examples:

```text
gold.calendar
gold.customer
gold.productcategories
gold.productsubcategories
gold.territories
gold.products
gold.returns
gold.sales
```

These objects provide a structured layer for analytical consumption.

---

# 📊 Power BI Layer

Power BI is connected to the Synapse serving layer.

The purpose of this layer is to provide business-friendly visualizations.

The dashboard can be used to analyze:

* Sales
* Products
* Customers
* Territories
* Returns
* Business KPIs

---

# 🔐 Security Architecture

Azure identity-based authentication is used where applicable.

The project uses concepts such as:

* Microsoft Entra ID
* Managed Identity
* Azure RBAC
* Storage access roles

Secrets and passwords are not stored in the GitHub repository.

---

# 🔁 Complete Data Flow

```text
GitHub
   ↓
Azure Data Factory
   ↓
ADLS Gen2 - Bronze
   ↓
Azure Databricks
   ↓
PySpark Transformation
   ↓
ADLS Gen2 - Silver
   ↓
Azure Synapse Serverless SQL
   ↓
Gold Views / External Tables
   ↓
Power BI
```

---

# 🎯 Architecture Objectives

The architecture was designed to:

1. Separate raw and transformed data.
2. Make ingestion reusable.
3. Perform transformations using PySpark.
4. Store transformed data in an efficient columnar format.
5. Provide a SQL-based serving layer.
6. Enable Power BI reporting.

---

# 🛠️ Azure Services Used

| Service                 | Purpose                          |
| ----------------------- | -------------------------------- |
| Azure Data Factory      | Data ingestion and orchestration |
| ADLS Gen2               | Data lake storage                |
| Azure Databricks        | Data transformation              |
| PySpark                 | Data processing                  |
| Azure Synapse Analytics | SQL serving layer                |
| Power BI                | Visualization                    |
| Microsoft Entra ID      | Authentication                   |
| Azure RBAC              | Authorization                    |

---

# 🎤 Interview Explanation

> "I designed the project using a Medallion Architecture. AdventureWorks CSV files are ingested from GitHub into the Bronze layer of ADLS Gen2 using Azure Data Factory. Azure Databricks reads the Bronze data and performs cleaning and transformation using PySpark, and the processed data is stored in Parquet format in the Silver layer. Azure Synapse Serverless SQL is then used to query the Silver data and create Gold views and external tables. Finally, Power BI consumes the serving layer for reporting and visualization."
