# 📊 Power BI – AdventureWorks Dashboard

## 📌 Overview

Power BI is used as the final basic visualization of AdventureWorks Azure Data Engineering project.

The Power BI report consumes data from the Azure Synapse serving layer.

The overall flow is:

```text
ADLS Silver
     |
     v
Azure Synapse
     |
     v
Gold Views / External Tables
     |
     v
Power BI
     |
     v
Dashboard
```

---

# 🎯 Objective

The objective of the Power BI layer is to convert the processed AdventureWorks data into interactive business reports and dashboards.

The report can be used to analyze:

* Sales
* Products
* Customers
* Territories
* Returns
* Business KPIs

---

# 🔗 Data Source

Power BI connects to the serving layer created in Azure Synapse Analytics.

```text
Azure Synapse Serverless SQL
```

The report uses the Gold layer objects.

Examples:

```text
gold.calendar
gold.customer
gold.productcategories
gold.productsubcategories
gold.products
gold.returns
gold.sales
```

---

# 🏗️ Power BI Data Flow

```text
             ADLS Gen2
                 |
                 v
          Silver Parquet
                 |
                 v
        Synapse Serverless SQL
                 |
                 v
          Gold Views/Tables
                 |
                 v
              Power BI
                 |
                 v
             Dashboard
```

# 📌 Why Power BI?

Power BI provides:

* Interactive dashboards
* Business-friendly visualizations
* Filtering and slicing
* Data exploration
* KPI reporting
* Trend analysis

---

# 🚀 End-to-End Reporting Architecture

```text
                 GitHub
                    |
                    v
            Azure Data Factory
                    |
                    v
             ADLS Bronze
                    |
                    v
          Azure Databricks
                    |
                    v
             ADLS Silver
                    |
                    v
          Azure Synapse SQL
                    |
                    v
              Gold Layer
                    |
                    v
                Power BI
                    |
                    v
              Dashboard
```

---

# 🎤 Interview Explanation

> "Power BI is the final reporting layer of my project. I connected Power BI to the Gold serving layer created in Azure Synapse Serverless SQL. The Gold layer contains views and external tables built over the transformed Silver Parquet data. I used these datasets to create a basic Adventure Works dashboard. This completes the end-to-end flow from source data ingestion to business reporting."

---


