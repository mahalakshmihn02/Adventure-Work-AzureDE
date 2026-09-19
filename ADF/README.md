# 🔥 Azure Data Factory – AdventureWorks Data Ingestion

## 📌 Overview

Azure Data Factory (ADF) is used in this project for **data ingestion and pipeline orchestration**.

The pipeline uses a **metadata-driven approach** to dynamically read multiple AdventureWorks CSV files from GitHub and load them into the Bronze layer of ADLS Gen2.

```text
GitHub Repository
       |
       v
JSON Metadata
       |
       v
Azure Data Factory
       |
       v
Lookup Activity
       |
       v
ForEach Activity
       |
       v
Dynamic Copy Activity
       |
       v
ADLS Bronze
```

---

# 🎯 Objective

The main objectives of the ADF ingestion layer are:

* Read AdventureWorks dataset information from metadata
* Dynamically process multiple CSV files
* Read files from GitHub using HTTP
* Use Lookup activity to read metadata
* Use ForEach activity to process multiple files
* Use dynamic parameters for source and destination paths
* Load raw data into ADLS Gen2 Bronze
* Create a reusable ingestion pipeline

---

# 🗂️ Source Data

The source AdventureWorks CSV files are stored in a GitHub repository.

The project works with the following datasets:

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

# 📄 Metadata File

The pipeline uses a JSON metadata file:

```text
parameters/adventure_work_git.json
```

The metadata contains:

| Parameter   | Description               |
| ----------- | ------------------------- |
| `p_rel_url` | Source relative URL       |
| `p_folder`  | Bronze destination folder |
| `p_file`    | Destination file name     |

Example:

```text
p_rel_url = <GitHub file path>
p_folder  = AdventureWorks_Sales
p_file    = AdventureWorks_Sales.csv
```

The metadata allows the same pipeline to process multiple files without creating separate Copy Activities.

---

# 🔍 Lookup Activity

The first activity in the pipeline is:

```text
Lookupgit
```

The Lookup activity reads the metadata JSON file.

Configuration:

* Dataset: `ds_gitjson`
* Linked Service: `ls_storageaccount`
* Reads metadata records
* Passes the output to the ForEach activity

```text
Metadata JSON
      |
      v
  Lookupgit
      |
      v
Metadata Records
```

---

# 🔁 ForEach Activity

The next activity is:

```text
ForEachGit
```

The ForEach activity processes each metadata record.

Items expression:

```adf
@activity('Lookupgit').output.value
```

Sequential processing is enabled, so the metadata records are processed one at a time.

```text
Lookup Output
     |
     v
ForEachGit
     |
     +---- File 1
     |
     +---- File 2
     |
     +---- File 3
     |
     +---- ...
```

---

# 📥 Dynamic Copy Activity

Inside the ForEach activity, the following Copy Activity is used:

```text
DynamicCopy
```

It dynamically reads the source file and writes it to the required Bronze folder.

## Source

Configuration:

* Dataset: `ds_dynamic_http_git`
* Linked Service: `ls_http_git`
* Base URL:

```text
https://raw.githubusercontent.com/
```

Dynamic source parameter:

```adf
@item().p_rel_url
```

The source file path changes dynamically for every metadata record.

---

# 📤 Sink

The destination uses:

* Dataset: `ds_dynamic_bronze`
* Linked Service: `ls_storageaccount`

The destination path is:

```text
bronze/@dataset().p_folder/@dataset().p_file
```

For example:

```text
bronze/AdventureWorks_Sales/AdventureWorks_Sales.csv
```

---

# 🔄 Parameter Flow

The metadata parameters are used dynamically throughout the pipeline.

```text
p_rel_url
    |
    v
Source GitHub File

p_folder
    |
    v
Bronze Folder

p_file
    |
    v
Destination File
```

This makes the pipeline reusable for multiple datasets.

---

# 🏗️ Pipeline Flow

The complete pipeline flow is:

```text
GitHub
   |
   v
JSON Metadata
   |
   v
Lookupgit
   |
   v
ForEachGit
   |
   v
DynamicCopy
   |
   v
ADLS Gen2 Bronze
```

---

# 📦 Bronze Layer

The raw CSV files are stored in the Bronze layer of ADLS Gen2.

Example:

```text
bronze/
│
├── AdventureWorks_Calendar/
├── AdventureWorks_Customers/
├── AdventureWorks_Product_Categories/
├── AdventureWorks_Product_Subcategories/
├── AdventureWorks_Products/
├── AdventureWorks_Returns/
├── AdventureWorks_Sales/
└── AdventureWorks_Territories/
```

The Bronze layer contains the raw ingested data before transformation.

---

# 🔄 Metadata-Driven Ingestion

The pipeline is metadata-driven because the source file, destination folder, and destination file name are provided through the JSON metadata.

```text
Metadata
   |
   +---- Source Path
   |
   +---- Destination Folder
   |
   +---- Destination File
   |
   v
Reusable Pipeline
```

This avoids creating separate pipelines or Copy Activities for each dataset.

---

# 🗂️ Project Structure

```text
ADF/
│
├── dataset/
│   ├── ds_gitjson
│   ├── ds_dynamic_http_git
│   └── ds_dynamic_bronze
│
├── linkedService/
│   ├── ls_storageaccount
│   └── ls_http_git
│
└── pipeline/
    └── DynamicIngestion_to_bronzecontainer
```

---

# 🧪 Pipeline Components

| Component           | Purpose                    |
| ------------------- | -------------------------- |
| Lookupgit           | Reads metadata             |
| ForEachGit          | Processes metadata records |
| DynamicCopy         | Copies files dynamically   |
| ds_gitjson          | Metadata dataset           |
| ds_dynamic_http_git | GitHub source dataset      |
| ds_dynamic_bronze   | Bronze sink dataset        |
| ls_http_git         | HTTP connection            |
| ls_storageaccount   | ADLS Gen2 connection       |

---

# 🎯 Key Concepts

* **Azure Data Factory**
* **Metadata-driven ingestion**
* **Lookup Activity**
* **ForEach Activity**
* **Copy Activity**
* **Dataset parameters**
* **Dynamic expressions**
* **Dynamic source path**
* **Dynamic sink path**
* **HTTP/GitHub ingestion**
* **ADLS Gen2**
* **Bronze layer**
* **Pipeline orchestration**

---

# 🎤 Interview Explanation

> "I used Azure Data Factory for the data ingestion layer of my AdventureWorks project. I created a metadata-driven pipeline called `DynamicIngestion_to_bronzecontainer`. The pipeline first reads the JSON metadata using a Lookup activity. The metadata output is passed to a ForEach activity, which processes each record sequentially. Inside the ForEach, a dynamic Copy Activity reads the CSV files from GitHub using HTTP and loads them into the Bronze layer of ADLS Gen2. I used dynamic parameters for the source URL, destination folder and file name, which makes the pipeline reusable for multiple datasets."
