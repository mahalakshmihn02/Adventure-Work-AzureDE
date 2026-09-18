# 🔥 Azure Databricks – AdventureWorks Transformation

## 📌 Overview

Azure Databricks is used in this project to transform the raw AdventureWorks data from the Bronze layer into cleaned and structured data for the Silver layer.

The transformation is implemented using **Apache Spark and PySpark**.

```text
ADLS Bronze
     |
     v
Azure Databricks
     |
     v
PySpark DataFrames
     |
     v
Data Cleaning
     |
     v
Data Transformation
     |
     v
ADLS Silver
     |
     v
Parquet
```

---

# 🎯 Objective

The main objectives of the Databricks transformation layer are:

* Read raw CSV files from Bronze
* Create Spark DataFrames
* Check data types
* Check null values
* Check duplicate records
* Remove duplicate records
* Perform data cleaning
* Prepare the data for analytical use
* Store the transformed data in Parquet format

---

# 🗂️ Source Data

The source data is stored in the Bronze container of ADLS Gen2.

The project works with the following AdventureWorks entities:

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

---

# 📥 Reading Data from Bronze

The Bronze CSV files are read using Spark.

Example:

```python
df_cal = spark.read.csv(
    'abfss://bronze@<storage-account>.dfs.core.windows.net/AdventureWorks_Calendar',
    header=True,
    inferSchema=True
)
```

The same approach is used for the other datasets.

---

# 📊 DataFrames

The project creates DataFrames for the AdventureWorks entities.

Examples:

```python
df_cal
df_cus
df_p_cat
df_p_subcats
df_prod
df_returns
df_sales
df_territories
```

The DataFrames are then used for data quality checks and transformations.

---

# 🔍 Schema Check

The schema of a DataFrame can be checked using:

```python
df_cal.printSchema()
```

This helps identify:

* Column names
* Data types
* Nullable columns
* Incorrectly inferred data types

---

# 🔎 Display Data

To display sample records:

```python
df_cal.show()
```

To display a larger number of records:

```python
df_cal.show(10)
```

---

# ❌ Null Value Check

Null values are checked before writing the data to Silver.

Example:

```python
from pyspark.sql.functions import col, count, when

df_cus.select([
    count(when(col(c).isNull(), c)).alias(c)
    for c in df_cus.columns
]).show()
```

This helps identify columns containing missing values.

---

# 🔁 Duplicate Check

Duplicate records are checked before transformation.

Example:

```python
print("Before removing duplicates:", df_cus.count())

df_cus = df_cus.dropDuplicates()

print("After removing duplicates:", df_cus.count())
```

This provides a simple before-and-after comparison.

---

# 🧹 Data Cleaning

The Silver transformation process includes activities such as:

* Removing duplicate records
* Handling null values
* Correcting data types
* Renaming columns where required
* Selecting required columns
* Applying basic transformations

The objective is to create clean and consistent datasets for the next layer.

---

# 🔄 Silver Data

After transformation, the DataFrames are written to the Silver layer.

The Silver data is stored in **Parquet format**.

Example:

```python
df_cus.write.mode("overwrite").parquet(
    "abfss://silver@<storage-account>.dfs.core.windows.net/AdventureWorks_Customers"
)
```

---

# 📦 Why Parquet?

Parquet is used for the Silver layer because it is a columnar storage format suitable for analytical workloads.

Advantages include:

* Column-based storage
* Efficient analytical queries
* Compression
* Better performance for selective column reads
* Suitable for Spark processing

---

# 🔄 Bronze to Silver Flow

```text
Bronze CSV
     |
     v
Spark Read
     |
     v
DataFrame
     |
     +------> Schema Check
     |
     +------> Null Check
     |
     +------> Duplicate Check
     |
     +------> Data Cleaning
     |
     v
Transformed DataFrame
     |
     v
Silver Parquet
```

---

# 📊 Silver Datasets

The Silver layer contains transformed versions of the AdventureWorks datasets.

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

---

# 🧪 Data Quality Checks

The transformation process includes basic data quality validation.

| Check           | Purpose                    |
| --------------- | -------------------------- |
| Schema Check    | Verify column data types   |
| Null Check      | Identify missing values    |
| Duplicate Check | Identify duplicate records |
| Count Check     | Compare record counts      |
| Data Inspection | Verify transformed records |

---

# 📈 Record Count Validation

Record counts can be checked after transformation.

Example:

```python
print("Calendar:", df_cal_silver.count())
print("Customers:", df_cus_silver.count())
print("Product Categories:", df_p_cat_silver.count())
print("Product Subcategories:", df_p_subcats_silver.count())
print("Products:", df_prod_silver.count())
print("Returns:", df_returns_silver.count())
print("Sales:", df_sales_silver.count())
print("Territories:", df_territories_silver.count())
```

This helps confirm that the expected datasets have been processed.

---

# 🎤 Interview Explanation

> "I used Azure Databricks for the Bronze-to-Silver transformation. I read the raw CSV files from ADLS Gen2 using PySpark and created DataFrames for the AdventureWorks datasets. I performed null checks and duplicate checks, followed by data cleansing and transformations. After processing, I stored the transformed datasets in Parquet format in the Silver layer. This Silver data is then consumed by Azure Synapse for the serving layer."
