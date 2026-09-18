# 🔥 Azure Databricks

## Overview

Azure Databricks is used to transform the raw data from the **Bronze layer** into clean data for the **Silver layer**.

```text
ADLS Bronze
     |
     v
Azure Databricks
     |
     v
PySpark
     |
     v
Data Cleaning
     |
     v
ADLS Silver - Parquet
```

## Data Processing

The AdventureWorks datasets are read from ADLS using PySpark.

Main DataFrames include:

```text
Calendar
Customers
Product Categories
Product Subcategories
Products
Returns
Sales
Territories
```

## Transformations

The following checks and transformations are performed:

* Null value checking
* Duplicate checking
* Duplicate removal

Example:

```python
print("Before:", df_cus.count())

df_cus = df_cus.dropDuplicates()

print("After:", df_cus.count())
```

## Silver Layer

After transformation, the data is stored in **Parquet format** in ADLS Gen2.

Parquet provides efficient storage and is suitable for analytical processing.

## Technologies

* Azure Databricks
* Apache Spark
* PySpark
* ADLS Gen2
* Parquet
