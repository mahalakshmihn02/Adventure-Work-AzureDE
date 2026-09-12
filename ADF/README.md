# Azure Data Factory

Azure Data Factory (ADF) is used for **data ingestion and orchestration** in this project.

## Pipeline

**Pipeline:** `DynamicIngestion_to_bronzecontainer`

### Pipeline Flow

```text
JSON Metadata
     ↓
 Lookupgit
     ↓
 ForEachGit
     ↓
 DynamicCopy
     ↓
GitHub / HTTP
     ↓
ADLS Gen2 Bronze
```

## Metadata-Driven Ingestion

The pipeline uses the metadata file:

```text
parameters/adventure_work_git.json
```

The metadata contains:

| Parameter   | Description               |
| ----------- | ------------------------- |
| `p_rel_url` | Source relative URL       |
| `p_folder`  | Bronze destination folder |
| `p_file`    | Destination file name     |

This allows the same pipeline to process multiple files without creating separate Copy Activities.

## Lookup Activity

**Activity:** `Lookupgit`

* Dataset: `ds_gitjson`
* Linked Service: `ls_storageaccount`
* Reads all records from the metadata JSON.
* Output is passed to the ForEach activity.

## ForEach Activity

**Activity:** `ForEachGit`

Uses:

```adf
@activity('Lookupgit').output.value
```

Sequential processing is enabled, so metadata records are processed one at a time.

## Dynamic Copy Activity

**Activity:** `DynamicCopy`

### Source

* Dataset: `ds_dynamic_http_git`
* Linked Service: `ls_http_git`
* Base URL: `https://raw.githubusercontent.com/`
* Dynamic parameter:

```adf
@item().p_rel_url
```

### Sink

* Dataset: `ds_dynamic_bronze`
* Linked Service: `ls_storageaccount`

Destination:

```text
bronze/@dataset().p_folder/@dataset().p_file
```

## Parameter Flow

```text
p_rel_url  → Source URL
p_folder   → Bronze Folder
p_file     → Destination File
```

Example:

```text
p_rel_url = <GitHub file path>
p_folder  = AdventureWorks_Sales
p_file    = AdventureWorks_Sales.csv
```

Output:

```text
bronze/AdventureWorks_Sales/AdventureWorks_Sales.csv
```

# End-to-End Architecture

```text
                  GitHub Repository
                         |
                         | HTTP
                         v
               ┌────────────────────┐
               │   Source Dataset   │
               │ ds_dynamic_http_git│
               └──────────┬─────────┘
                          |
                          v
                 Azure Data Factory
                          |
               ┌──────────┴─────────┐
               │      Lookupgit      │
               │    Read Metadata    │
               └──────────┬─────────┘
                          |
                          v
               ┌────────────────────┐
               │     ForEachGit      │
               │   Sequential Loop   │
               └──────────┬─────────┘
                          |
                          v
               ┌────────────────────┐
               │     DynamicCopy     │
               │  Dynamic Parameters │
               └──────────┬─────────┘
                          |
                          v
               ┌────────────────────┐
               │      ADLS Gen2      │
               │    Bronze Layer     │
               └────────────────────┘
```

---

# Project Structure

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

# Key Concepts:

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

# Summary

The `DynamicIngestion_to_bronzecontainer` pipeline implements a **metadata-driven data ingestion framework using Azure Data Factory**.

The pipeline reads file configuration from:

```text
parameters/adventure_work_git.json
```

The **Lookup** activity retrieves the metadata records, the **ForEach** activity processes each record sequentially, and the **DynamicCopy** activity dynamically retrieves files from GitHub and loads them into the **Bronze layer of ADLS Gen2**.

This provides a **dynamic, reusable, scalable, and maintainable solution** for processing multiple AdventureWorks datasets.
