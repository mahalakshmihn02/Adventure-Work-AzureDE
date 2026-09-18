# 📊 AdventureWorks Dataset

## 📌 Overview

This folder contains the dataset information used in the AdventureWorks Azure Data Engineering project.

The project uses AdventureWorks business data to demonstrate an end-to-end Azure data engineering pipeline.

The data is initially available as CSV files and is ingested into Azure Data Lake Storage Gen2 using Azure Data Factory.

---

# 📂 Dataset Flow

```text
AdventureWorks CSV Files
          |
          v
       GitHub
          |
          v
Azure Data Factory
          |
          v
ADLS Gen2 - Bronze
          |
          v
Azure Databricks
          |
          v
ADLS Gen2 - Silver
```

---

# 📁 Dataset Entities

The project contains the following major business entities:

| Dataset               | Description                     |
| --------------------- | ------------------------------- |
| Calendar              | Date and calendar information   |
| Customers             | Customer information            |
| Product Categories    | Product category information    |
| Product Subcategories | Product subcategory information |
| Products              | Product information             |
| Returns               | Product return information      |
| Sales                 | Sales transaction information   |
| Territories           | Sales territory information     |

---

# 📅 Calendar

The Calendar dataset contains date-related information used for analysis.

It can be used for:

* Date analysis
* Year analysis
* Month analysis
* Time-based reporting

---

# 👥 Customers

The Customers dataset contains customer-related information.

It can be used for:

* Customer analysis
* Customer segmentation
* Sales by customer
* Geographic/customer analysis

---

# 🗂️ Product Categories

This dataset contains the main product categories.

It provides a high-level classification of products.

Example hierarchy:

```text
Product Category
       |
       v
Product Subcategory
       |
       v
Product
```

---

# 📂 Product Subcategories

The Product Subcategories dataset provides a more detailed classification under each product category.

It is used together with Product Categories and Products for product hierarchy analysis.

---

# 🛍️ Products

The Products dataset contains product-level information.

It can be used to analyze:

* Product names
* Product categories
* Product subcategories
* Product performance
* Sales by product

---

# ↩️ Returns

The Returns dataset contains information about returned products.

It can be used for:

* Return analysis
* Product return trends
* Return quantity analysis
* Product-level return analysis

---

# 💰 Sales

The Sales dataset contains sales transaction information.

It is one of the main datasets used for business analysis.

It can be used to analyze:

* Sales amount
* Order quantity
* Product sales
* Customer sales
* Territory sales
* Sales trends

---

# 🌎 Territories

The Territories dataset contains geographical or sales territory information.

It can be used for:

* Territory-level analysis
* Regional sales analysis
* Geographic reporting

---

# 🥉 Bronze Dataset

The source CSV files are initially stored in the Bronze layer.

The Bronze layer preserves the raw data received from the source.

```text
Bronze
│
├── Calendar
├── Customers
├── Product Categories
├── Product Subcategories
├── Products
├── Returns
├── Sales
└── Territories
```

---

# 🥈 Silver Dataset

After processing with Databricks and PySpark, the transformed data is stored in the Silver layer.

The Silver layer is stored in Parquet format.

```text
Silver
│
├── Calendar
├── Customers
├── Product Categories
├── Product Subcategories
├── Products
├── Returns
├── Sales
└── Territories
```

---

# 🥇 Gold / Serving Dataset

The Silver Parquet data is queried through Azure Synapse Serverless SQL.

The serving layer contains objects such as:

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

---

# 🔄 Dataset Transformation

```text
Raw CSV
   |
   v
Bronze
   |
   | Databricks / PySpark
   v
Cleaned Data
   |
   v
Silver Parquet
   |
   | Synapse Serverless SQL
   v
Gold Views / External Tables
   |
   v
Power BI
```

---

# 🎯 Purpose of the Dataset

The AdventureWorks dataset is used to demonstrate:

* Data ingestion
* Data lake storage
* Data transformation
* Data quality checks
* Data serving
* SQL analytics
* Business intelligence

---

# 📌 Data Quality

During the transformation process, the datasets are checked for:

* Null values
* Duplicate records
* Data types
* Record counts
* Data consistency

These checks are performed before the data is written to the Silver layer.

---

# ⚠️ Note

The dataset is used for learning and portfolio purposes.

The project demonstrates the technical implementation of a modern Azure Data Engineering pipeline using publicly available AdventureWorks data.
