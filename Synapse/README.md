# 🔷 Azure Synapse Analytics – Gold / Serving Layer

## 📌 Overview

Azure Synapse Analytics is used in this project as the **SQL serving and analytical layer**.

The transformed Silver data is stored as Parquet files in ADLS Gen2.

Synapse Serverless SQL is used to query these Parquet files and expose the data through SQL views and external tables.

---

# 🏗️ Synapse Architecture

```text
ADLS Gen2
   |
   | Silver Parquet
   v
Azure Synapse Analytics
   |
   v
Serverless SQL
   |
   +----------------------+
   |                      |
   v                      v
Gold Views          External Tables
   |                      |
   +----------+-----------+
              |
              v
           Power BI
```

---

# 🎯 Objective

The main objectives of the Synapse layer are:

* Query Silver Parquet data using SQL
* Create a structured serving layer
* Create a Gold schema
* Create reusable SQL views
* Create external tables
* Provide data for Power BI reporting

---

# 🗄️ Database Setup

The project uses a Serverless SQL database:

```text
awdb
```

A schema is created inside the database:

```text
gold
```

The Gold schema is used to organize the analytical views and serving objects.

---

# 🔐 Storage Access

Synapse requires access to the ADLS Gen2 storage account containing the Silver data.

The Synapse workspace managed identity is granted the required storage permissions.

This allows Synapse Serverless SQL to access the Parquet files stored in ADLS Gen2.

---

# 📂 Silver Data Location

The Silver layer contains transformed Parquet files.

Conceptually:

```text
ADLS Gen2
   |
   └── silver
        |
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

# 🔎 OPENROWSET

Synapse Serverless SQL uses `OPENROWSET` to query Parquet files directly from ADLS Gen2.

Example:

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage-account>.blob.core.windows.net/silver/<folder>/',
    FORMAT = 'PARQUET'
) AS Query1;
```

This allows the data to be queried without first loading the Parquet files into a traditional database table.

---

# 👁️ Gold Views

Views are created under the `gold` schema.

The project contains views for the major AdventureWorks entities.

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

# 📊 View Structure

The general process is:

```text
Silver Parquet
      |
      v
OPENROWSET
      |
      v
SQL Query
      |
      v
Gold View
```

The views provide a consistent SQL interface for downstream analytics.

---

# 🧱 External Tables

External tables are also used as part of the serving layer.

The external table configuration defines:

* External data source
* External file format
* External table
* Location of the underlying data

Conceptually:

```text
ADLS Silver
     |
     v
External Data Source
     |
     v
External File Format
     |
     v
External Table
```

---

# 📁 Synapse Objects

The project can be organized as:

```text
Synapse/
│
├── README.md
│
├── database_setup.sql
│
├── views/
│   ├── calendar.sql
│   ├── customer.sql
│   ├── productcategories.sql
│   ├── productsubcategories.sql
│   ├── territories.sql
│   ├── products.sql
│   ├── returns.sql
│   └── sales.sql
│
└── external_tables/
    └── external table scripts
```

The exact filenames can be adjusted to match the scripts stored in the repository.

---

# 🔄 Complete Synapse Flow

```text
ADLS Gen2 Silver
       |
       v
Parquet Files
       |
       v
OPENROWSET
       |
       v
Serverless SQL
       |
       +----------------+
       |                |
       v                v
    Views        External Tables
       |                |
       +-------+--------+
               |
               v
            Power BI
```

---

# 📈 Why Serverless SQL?

Serverless SQL is useful in this project because the transformed data already exists as Parquet files in the data lake.

Instead of loading all data into a dedicated warehouse, Synapse can query the files directly.

This provides a simple serving layer for analytical workloads.

---

# 🔐 Security

The project uses Azure identity-based access.

The Synapse workspace is given the required access to the storage account.

Important security practices:

* Use Managed Identity where applicable
* Use Azure RBAC
* Do not store secrets in SQL scripts
* Do not commit storage account keys
* Do not commit passwords

---

# 🔗 Power BI Integration

Power BI consumes the Synapse serving layer.

The general flow is:

```text
Synapse Serverless SQL
          |
          v
Gold Views / External Tables
          |
          v
Power BI
```

This separates data processing from reporting.

---

# 🧪 Validation

The Synapse layer can be validated by checking:

### View existence

```sql
SELECT *
FROM gold.customer;
```

### Record count

```sql
SELECT COUNT(*)
FROM gold.customer;
```

### Sample records

```sql
SELECT TOP 10 *
FROM gold.customer;
```

Similar queries can be executed against the other Gold views.

---

# 🎤 Interview Explanation

> "I used Azure Synapse Analytics Serverless SQL as the serving layer. The transformed Silver data is stored as Parquet files in ADLS Gen2. I created a Serverless SQL database called awdatabase and a gold schema. Using OPENROWSET, I queried the Silver Parquet files directly and created Gold views for entities such as customers, products, sales, returns and territories. I also worked with external tables as part of the serving layer. Power BI then consumes these Gold objects for reporting."

---

# 📚 Key Synapse Concepts Used

* Azure Synapse Analytics
* Serverless SQL Pool
* SQL Database
* Schema
* OPENROWSET
* Parquet
* SQL Views
* External Tables
* External Data Source
* External File Format
* Managed Identity
* Azure RBAC
* Power BI Integration

