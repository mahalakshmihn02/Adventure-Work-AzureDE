# 📊 AdventureWorks Dataset

## Overview

This project uses the **AdventureWorks dataset** to demonstrate an end-to-end Azure Data Engineering pipeline.

The source data is available as CSV files and is ingested from GitHub using Azure Data Factory.

## Datasets Used

| Dataset               | Description           |
| --------------------- | --------------------- |
| Calendar              | Date information      |
| Customers             | Customer information  |
| Product Categories    | Product categories    |
| Product Subcategories | Product subcategories |
| Products              | Product information   |
| Returns               | Return information    |
| Sales                 | Sales transactions    |
| Territories           | Territory information |

## Data Flow

```text
AdventureWorks CSV
        |
        v
      GitHub
        |
        v
Azure Data Factory
        |
        v
ADLS Bronze
        |
        v
Databricks
        |
        v
ADLS Silver
```

## Data Quality

During Databricks processing, the following checks are performed:

* Null value check
* Duplicate check
* Record count validation

The cleaned data is stored as Parquet files in the Silver layer.
