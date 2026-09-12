# Azure Data Factory – Dynamic Ingestion Pipeline

Azure Data Factory (ADF) is used in this project as the **data ingestion and orchestration service**.

The pipeline implements a **metadata-driven ingestion framework** that dynamically reads file details from a JSON metadata file and loads multiple files from GitHub into the **Bronze layer of Azure Data Lake Storage Gen2 (ADLS Gen2)**.

---

## 📌 Pipeline Overview

**Pipeline Name**

`DynamicIngestion_to_bronzecontainer`

### Pipeline Flow

```text
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
               GitHub / HTTP Source
                       |
                       v
               ADLS Gen2 Bronze
```

---

# 🔄 Metadata-Driven Ingestion

The pipeline uses a JSON metadata file to dynamically control the source and destination details.

**Metadata File**

```text
parameters/adventure_work_git.json
```

The metadata file contains the following fields:

| Field       | Description                            |
| ----------- | -------------------------------------- |
| `p_rel_url` | Relative URL of the source file        |
| `p_folder`  | Destination folder in the Bronze layer |
| `p_file`    | Destination file name                  |

### Why Metadata-Driven Ingestion?

Instead of creating a separate pipeline or Copy Activity for every file, the same pipeline can process multiple files based on the metadata provided in the JSON file.

This makes the solution:

* ✅ Dynamic
* ✅ Reusable
* ✅ Scalable
* ✅ Easier to maintain
* ✅ Less dependent on hardcoded file paths

---

# 🔍 Lookup Activity

### Activity Name

`Lookupgit`

The **Lookup** activity reads the JSON metadata file using the dataset:

```text
ds_gitjson
```

### Configuration

| Configuration  | Value                                |
| -------------- | ------------------------------------ |
| Dataset        | `ds_gitjson`                         |
| Linked Service | `ls_storageaccount`                  |
| Metadata File  | `parameters/adventure_work_git.json` |
| First Row Only | Disabled                             |

The dataset is connected to the Azure Storage Account through the linked service:

```text
ls_storageaccount
```

Since **First row only** is not selected, the Lookup activity returns **all metadata records** from the JSON file.

The output of the Lookup activity is then passed to the **ForEach** activity.

---

# 🔁 ForEach Activity

### Activity Name

`ForEachGit`

The ForEach activity receives the output of the Lookup activity using:

```adf
@activity('Lookupgit').output.value
```

### Processing Mode

**Sequential processing:** Enabled

This means the metadata records are processed **one at a time**.

Inside the ForEach activity, the following Copy Activity is executed:

```text
DynamicCopy
```

---

# 📥 Dynamic Copy Activity

### Activity Name

`DynamicCopy`

The `DynamicCopy` activity uses the source and sink datasets to dynamically determine where the data should be read from and where it should be written.

### Source Dataset

```text
ds_dynamic_http_git
```

### Sink Dataset

```text
ds_dynamic_bronze
```

The source and sink parameters are populated dynamically using values from the current metadata record.

---

# 🌐 Source Dataset

### Dataset

```text
ds_dynamic_http_git
```

### Linked Service

```text
ls_http_git
```

### Base URL

```text
https://raw.githubusercontent.com/
```

### Relative URL Parameter

```adf
@dataset().p_rel_url
```

The relative URL is passed dynamically from the metadata file.

The current metadata item provides the value through:

```adf
@item().p_rel_url
```

This allows the pipeline to dynamically access different files from GitHub without modifying the Copy Activity.

---

# 💾 Sink Dataset

### Dataset

```text
ds_dynamic_bronze
```

### Linked Service

```text
ls_storageaccount
```

### Destination Path

```text
bronze/@dataset().p_folder/@dataset().p_file
```

The destination folder and file name are dynamically generated using values from the metadata file.

---

# ⚙️ Dynamic Parameter Flow

The overall parameter flow through the pipeline is:

```text
                  JSON Metadata
                       |
          +------------+------------+
          |            |            |
     p_rel_url      p_folder      p_file
          |            |            |
          +------------+------------+
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
          +------------+------------+
          |            |            |
          v            v            v
       Source      Sink Folder   Sink File
          |            |            |
@item().p_rel_url  @item().p_folder  @item().p_file
```

---

# 🧩 How Dynamic Parameters Work

For each metadata record, the pipeline retrieves three important values:

```text
p_rel_url
p_folder
p_file
```

These values are then used by the Copy Activity to dynamically determine the source and destination.

### Parameter Mapping

| Metadata Parameter | Used By     | Expression          |
| ------------------ | ----------- | ------------------- |
| `p_rel_url`        | Source      | `@item().p_rel_url` |
| `p_folder`         | Sink Folder | `@item().p_folder`  |
| `p_file`           | Sink File   | `@item().p_file`    |

---

# 📄 Example Metadata Record

For example, one metadata record may contain:

```text
p_rel_url = <GitHub relative file path>
p_folder  = AdventureWorks_Sales
p_file    = AdventureWorks_Sales.csv
```

The Copy Activity dynamically uses these values to determine the destination.

### Resulting Bronze Path

```text
bronze/AdventureWorks_Sales/AdventureWorks_Sales.csv
```

The same pipeline can process additional AdventureWorks files by simply adding their corresponding metadata records to the JSON file.

---

# 🏗️ End-to-End Architecture

```text
                  GitHub Repository
                         |
                         | HTTP
                         v
               ┌───────────────────┐
               │   Source Dataset  │
               │ ds_dynamic_http_git│
               └─────────┬─────────┘
                         |
                         v
                Azure Data Factory
                         |
               ┌─────────┴─────────┐
               │   Lookupgit       │
               │  Read Metadata    │
               └─────────┬─────────┘
                         |
                         v
               ┌───────────────────┐
               │    ForEachGit     │
               │ Sequential Loop   │
               └─────────┬─────────┘
                         |
                         v
               ┌───────────────────┐
               │    DynamicCopy    │
               │ Dynamic Parameters│
               └─────────┬─────────┘
                         |
                         v
               ┌───────────────────┐
               │     ADLS Gen2     │
               │   Bronze Layer    │
               └───────────────────┘
```

---

# 📂 Project Structure

A simplified structure of the ADF implementation is:

```text
ADF/
│
├── parameters/
│   └── adventure_work_git.json
│
├── datasets/
│   ├── ds_gitjson
│   ├── ds_dynamic_http_git
│   └── ds_dynamic_bronze
│
├── linkedServices/
│   ├── ls_storageaccount
│   └── ls_http_git
│
└── pipelines/
    └── DynamicIngestion_to_bronzecontainer
```

---

# 🚀 Key Concepts Demonstrated

This pipeline demonstrates the following Azure Data Factory concepts:

* **Azure Data Factory**
* **Metadata-driven ingestion**
* **Dynamic pipeline design**
* **Lookup Activity**
* **ForEach Activity**
* **Copy Activity**
* **Dataset parameters**
* **Pipeline expressions**
* **Dynamic source path**
* **Dynamic sink path**
* **Azure Data Lake Storage Gen2**
* **HTTP/GitHub data ingestion**
* **Sequential processing**
* **Reusable pipeline architecture**

---

# 🎯 Benefits of the Solution

### 1. Reusability

The same pipeline can process multiple files without creating separate pipelines.

### 2. Dynamic Processing

Source URLs, destination folders, and file names are controlled through metadata.

### 3. Maintainability

Changes to file locations or destinations can be managed through the metadata file instead of modifying the pipeline.

### 4. Scalability

Additional files can be added by adding new metadata records.

### 5. Reduced Hardcoding

The pipeline minimizes hardcoded source and destination paths.

---

# ✅ Summary

The `DynamicIngestion_to_bronzecontainer` pipeline implements a **metadata-driven data ingestion framework using Azure Data Factory**.

The pipeline reads file configuration from:

```text
parameters/adventure_work_git.json
```

The **Lookup** activity retrieves all metadata records, the **ForEach** activity processes each record sequentially, and the **DynamicCopy** activity dynamically retrieves files from GitHub and loads them into the **Bronze layer of ADLS Gen2**.

This approach provides a **dynamic, reusable, scalable, and maintainable ingestion solution** for processing multiple AdventureWorks datasets.
