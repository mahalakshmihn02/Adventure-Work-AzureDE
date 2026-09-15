
# Azure Databricks – Bronze to Silver Transformation

This folder contains the **Azure Databricks PySpark transformation logic** used in the AdventureWorks Azure Data Engineering project.

The Databricks layer is responsible for reading raw CSV files from the **Bronze layer** of Azure Data Lake Storage Gen2, applying data cleansing and transformation rules using PySpark, and writing the processed datasets to the **Silver layer** in Parquet format.

---

## Role of Databricks in the Project

The overall project follows a multi-layer data engineering architecture:

```text
Kaggle AdventureWorks Dataset
            |
            v
       GitHub Repository
            |
            v
     Azure Data Factory
            |
            v
   ADLS Gen2 - Bronze
            |
            v
    Azure Databricks
     PySpark Processing
            |
            v
    ADLS Gen2 - Silver
            |
            v
     Azure Synapse
     Serverless SQL
            |
            v
       Gold Views /
    External Tables
            |
            v
         Power BI
```

Azure Databricks is used as the **transformation engine between the Bronze and Silver layers**.

---

## Notebook

The main notebook is:

```text
databricks/
└── bronze_to_silver.py
```

The original Databricks notebook is named:

```text
Silver_layer
```

and uses **Python/PySpark** for data processing.

---

## Technologies Used

| Technology                      | Purpose                             |
| ------------------------------- | ----------------------------------- |
| Azure Databricks                | Data transformation and processing  |
| Apache Spark / PySpark          | Distributed data processing         |
| Azure Data Lake Storage Gen2    | Bronze and Silver storage           |
| Azure Entra ID App Registration | Application-based authentication    |
| Parquet                         | Silver-layer storage format         |
| Python                          | Transformation and validation logic |

---

# 1. Data Access

The notebook connects Azure Databricks to the ADLS Gen2 storage account using OAuth authentication.

The authentication configuration uses:

* Azure Storage account
* OAuth authentication
* Azure Entra ID application/client ID
* Tenant authentication endpoint
* Client secret

The notebook then accesses the storage account using the `abfss://` protocol.

### Authentication Architecture

```text
Azure Databricks
       |
       | OAuth
       v
Azure Entra ID
       |
       | Application Identity
       v
ADLS Gen2
```

The application identity is granted access to the storage account through Azure IAM.

> **Security:** Client IDs, tenant IDs, client secrets, and other credentials must never be committed to GitHub. Use Databricks secret scopes, Azure Key Vault, environment variables, or another secure credential-management mechanism.

---

# 2. Reading Data from the Bronze Layer

The Bronze layer contains the CSV files ingested by Azure Data Factory.

The Databricks notebook reads the following AdventureWorks datasets:

| Dataset               | Bronze Location                        |
| --------------------- | -------------------------------------- |
| Calendar              | `AdventureWorks_Calendar`              |
| Customers             | `AdventureWorks_Customers`             |
| Product Categories    | `AdventureWorks_Product_Categories`    |
| Product Subcategories | `AdventureWorks_Product_Subcategories` |
| Products              | `AdventureWorks_Products`              |
| Returns               | `AdventureWorks_Returns`               |
| Territories           | `AdventureWorks_Territories`           |
| Sales                 | `AdventureWorks_Sales*`                |

The files are loaded into Spark DataFrames with:

* Header enabled
* Schema inference enabled
* CSV format

Example pattern:

```python
df = spark.read.csv(
    "abfss://bronze@<storage-account>.dfs.core.windows.net/<dataset>",
    header=True,
    inferSchema=True
)
```

---

# 3. Transformation Layer

After loading the Bronze datasets, PySpark transformations are applied before storing the data in the Silver layer.

The main transformation operations are:

```text
Bronze CSV
    |
    +--> Trim string columns
    |
    +--> Remove duplicate records
    |
    +--> Create derived columns
    |
    +--> Standardize selected values
    |
    +--> Clean selected identifiers
    |
    v
Silver Parquet
```

---

## 3.1 Remove Leading and Trailing Spaces

A reusable PySpark function is created to identify string columns and apply `trim()`.

```python
def trim_string_columns(df):
    for column_name, data_type in df.dtypes:
        if data_type == "string":
            df = df.withColumn(
                column_name,
                trim(col(column_name))
            )
    return df
```

This function is applied to the datasets before further processing.

### Why?

Removing unnecessary whitespace helps improve:

* Data consistency
* Filtering
* Joining
* Grouping
* Reporting quality

---

# 4. Calendar Transformation

The Calendar dataset is transformed by creating additional date attributes.

The notebook creates:

* `Month`
* `Year`
* `Quarter`

The transformations use Spark date functions such as:

```python
date_format()
year()
quarter()
concat()
```

The dataset is also deduplicated.

### Silver Output

```text
AdventureWorks_Calendar
```

is stored as Parquet in the Silver container.

---

# 5. Customer Transformation

The Customer dataset is processed using the reusable string-trimming function and duplicate removal.

A derived `FullName` column is created by combining:

```text
Prefix + FirstName + LastName
```

using:

```python
concat_ws()
```

### Example

```text
Prefix    FirstName    LastName
--------------------------------
Mr.       John         Smith
```

becomes:

```text
FullName
----------------
Mr. John Smith
```

The transformed customer data is then written to the Silver layer as Parquet.

---

# 6. Product Category Transformation

The Product Category dataset is:

1. Loaded from Bronze
2. String columns trimmed
3. Duplicate records removed
4. Written to the Silver layer

Output:

```text
AdventureWorks_Product_Categories
```

---

# 7. Product Subcategory Transformation

The Product Subcategory dataset follows a similar transformation pattern.

Processing includes:

* String trimming
* Duplicate removal
* Parquet conversion

Output:

```text
AdventureWorks_Product_SubCategories
```

---

# 8. Product Transformation

The Products dataset is cleaned and deduplicated.

An additional standardization is performed on the `ProductColor` column.

The notebook replaces:

```text
NA
```

with:

```text
Not Specified
```

This improves the readability and consistency of product attributes in downstream reporting.

Output:

```text
AdventureWorks_Products
```

---

# 9. Returns Transformation

The Returns dataset is processed by:

* Trimming string columns
* Removing duplicates

The transformed dataset is written to the Silver layer in Parquet format.

Output:

```text
AdventureWorks_Returns
```

---

# 10. Territories Transformation

The Territories dataset is processed using:

* String trimming
* Duplicate removal

The resulting data is written to the Silver layer.

---

# 11. Sales Transformation

The Sales dataset is one of the primary datasets used for downstream analysis.

The notebook performs:

* String trimming
* Duplicate removal
* Order number standardization

The `OrderNumber` column is transformed by adding a hyphen after the `SO` prefix.

Example:

```text
SO12345
```

becomes:

```text
SO-12345
```

The processed Sales dataset is then stored as Parquet in the Silver layer.

---

# 12. Silver Layer Storage

The transformed datasets are written using:

```python
.format("parquet")
.mode("append")
.option("path", "<silver-location>")
.save()
```

The Silver layer therefore contains cleaned and transformed Parquet datasets.

Conceptually:

```text
ADLS Gen2
│
├── bronze/
│   ├── AdventureWorks_Calendar
│   ├── AdventureWorks_Customers
│   ├── AdventureWorks_Products
│   ├── AdventureWorks_Sales
│   └── ...
│
└── silver/
    ├── AdventureWorks_Calendar
    ├── AdventureWorks_Customers
    ├── AdventureWorks_Products
    ├── AdventureWorks_Sales
    └── ...
```

Parquet was selected for the Silver layer because it is a columnar format that works efficiently with Spark and is suitable for downstream analytical workloads.

---

# 13. Sales Analysis

The notebook also contains exploratory analysis using the transformed Silver DataFrames.

## Analysis 1 – Orders and Quantity by Order Date

The Sales DataFrame is grouped by `OrderDate`.

The analysis calculates:

* Total Orders
* Total Quantity

Results are ordered by the most recent order date.

```python
df_sales_silver.groupBy("OrderDate") \
    .agg(
        count("OrderNumber").alias("TotalOrders"),
        sum("OrderQuantity").alias("TotalQuantity")
    )
```

---

## Analysis 2 – Top 10 Products by Quantity Sold

Sales data is joined with the Product dataset using:

```text
ProductKey
```

The analysis calculates:

* Total Quantity Sold
* Total Orders

The products are then ordered by total quantity sold and the top 10 products are displayed.

---

## Analysis 3 – Sales by Customer

Sales data is joined with Customer data using:

```text
CustomerKey
```

The analysis calculates:

* Total Orders
* Total Quantity

for each customer.

This provides a simple customer-level sales analysis that can also be used as a basis for downstream Power BI reporting.

---

# 14. Silver Layer Validation

After writing the transformed data, the notebook performs a validation step by reading the generated Parquet data back from the Silver layer.

Example:

```python
silver_cal = spark.read.parquet(
    "abfss://silver@<storage-account>.dfs.core.windows.net/AdventureWorks_Calendar"
)
```

The resulting DataFrame is displayed to verify that the Parquet files can be successfully read.

---

# 15. Data Quality Checks

The notebook contains basic data-quality checks.

## Null Check

Null values are counted for each column.

Example:

```python
df_cus_silver.select([
    count(when(col(c).isNull(), c)).alias(c)
    for c in df_cus_silver.columns
]).show()
```

Similar checks are performed for the Sales dataset.

---

## Record Count Validation

The notebook compares record counts before and after transformation.

The counts are displayed for:

* Calendar
* Customers
* Product Categories
* Product Subcategories
* Products
* Returns
* Territories
* Sales

This provides a basic way to validate the impact of duplicate removal and transformations.

Conceptually:

```text
Bronze Record Count
        |
        v
Transformation
        |
        v
Silver Record Count
```

---

# 16. Output of the Databricks Layer

The final output of this stage is cleaned Parquet data in the Silver layer.

```text
Bronze CSV
     |
     v
Azure Databricks
     |
     +-- Trim strings
     +-- Remove duplicates
     +-- Create derived columns
     +-- Standardize values
     +-- Transform identifiers
     +-- Validate data
     |
     v
Silver Parquet
```

The Silver data is subsequently consumed by **Azure Synapse Analytics**, where views and external tables are created for the Gold layer.

---

# 17. Relationship with Other Project Components

### Azure Data Factory

ADF performs the initial ingestion:

```text
GitHub
  ↓
ADF Dynamic Pipeline
  ↓
ADLS Bronze
```

### Azure Databricks

Databricks performs transformation:

```text
ADLS Bronze
  ↓
Databricks / PySpark
  ↓
ADLS Silver
```

### Azure Synapse

Synapse provides the SQL-based analytical layer:

```text
ADLS Silver
  ↓
Synapse Serverless SQL
  ↓
Gold Views / External Tables
```

### Power BI

Power BI consumes the analytical data for visualization:

```text
Synapse
  ↓
Power BI
  ↓
Dashboards & Reports
```

---

# 18. Files in This Folder

```text
databricks/
│
├── bronze_to_silver.py
└── README.md
```

### `bronze_to_silver.py`

Contains the PySpark implementation for:

* ADLS authentication
* Bronze data ingestion
* Data cleaning
* Data transformation
* Silver Parquet generation
* Sales analysis
* Silver validation
* Data-quality checks

### `README.md`

Documents the purpose, architecture, transformations, validation, and role of the Databricks layer.

---

# 19. Key Data Engineering Concepts Demonstrated

This Databricks implementation demonstrates practical experience with:

* Azure Databricks
* PySpark
* Spark DataFrames
* ADLS Gen2
* OAuth authentication
* Azure Entra ID application authentication
* CSV ingestion
* Parquet storage
* Data cleansing
* String transformation
* Date transformation
* Deduplication
* Data standardization
* Data-quality checks
* Record-count validation
* Data analysis using PySpark
* Bronze-to-Silver architecture

---

## End-to-End Databricks Flow

```text
                 ADLS GEN2
              ┌─────────────┐
              │   BRONZE    │
              │             │
              │ CSV Files   │
              └──────┬──────┘
                     │
                     │ ABFSS
                     ▼
            ┌─────────────────┐
            │ Azure Databricks│
            │                 │
            │     PySpark     │
            │                 │
            │ • Read CSV      │
            │ • Trim strings  │
            │ • Deduplicate   │
            │ • Transform     │
            │ • Validate      │
            └────────┬────────┘
                     │
                     │ Parquet
                     ▼
              ┌─────────────┐
              │   SILVER    │
              │             │
              │  Parquet    │
              └──────┬──────┘
                     │
                     ▼
              Azure Synapse
                     │
                     ▼
                  Power BI
```

---

## Security Note

The Databricks notebook used during development contains storage authentication configuration.

**Never commit client secrets, passwords, access keys, or other credentials to this repository.**

For a production implementation, credentials should be retrieved securely through mechanisms such as:

* Azure Key Vault
* Databricks Secret Scopes
* Managed Identity
* Service Principal with securely stored credentials
* Environment variables

Any credential accidentally exposed in source control should be **revoked/rotated immediately**.
