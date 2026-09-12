# Azure Data Factory

Azure Data Factory is used as the orchestration and data ingestion service in this project.

## Pipeline Name

`DynamicIngestion_to_bronzecontainer`

## Pipeline Flow

Lookup → ForEach → Copy Activity

## How the Pipeline Works

### 1. Lookup Activity

The Lookup activity reads the JSON metadata file stored in the data lake.

The JSON file contains information such as:

- Source relative URL
- Destination folder
- Destination file name

This allows the pipeline to process multiple files dynamically.

### 2. ForEach Activity

The output from the Lookup activity is passed to the ForEach activity.

The ForEach activity iterates through each file configuration received from the Lookup activity.

### 3. Copy Activity

Inside the ForEach activity, a parameterized Copy Activity copies the files from the source location into the Bronze container in Azure Data Lake Storage.

The source and destination paths are dynamically generated using parameters.

## Data Flow

GitHub / HTTP Source
        ↓
Azure Data Factory
        ↓
Lookup
        ↓
ForEach
        ↓
Parameterized Copy Activity
        ↓
ADLS Gen2 Bronze Container

## Key Concepts

- Azure Data Factory
- Lookup Activity
- ForEach Activity
- Copy Activity
- Parameterization
- Metadata-driven pipeline
- Dynamic ingestion
- Azure Data Lake Storage Gen2
