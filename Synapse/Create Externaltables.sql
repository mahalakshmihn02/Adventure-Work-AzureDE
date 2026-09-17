CREATE MASTER KEY ENCRYPTION BY PASSWORD ='password'

CREATE DATABASE SCOPED CREDENTIAL cred_aw
WITH IDENTITY = 'Managed Identity'

CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://awstoragedatalake11.dfs.core.windows.net/silver',
    CREDENTIAL = cred_aw
)

CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://awstoragedatalake11.dfs.core.windows.net/gold',
    CREDENTIAL = cred_aw
)

CREATE EXTERNAL FILE FORMAT format_parquet
WITH(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)


CREATE EXTERNAL TABLE gold.extcalendar
with(
LOCATION = 'extcalendar',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.calendar
 
CREATE EXTERNAL TABLE gold.extcustomer
with(
LOCATION = 'extcustomer',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.Customer

CREATE EXTERNAL TABLE gold.extproductcategories
with(
LOCATION = 'extproductcategories',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.productcategories

CREATE EXTERNAL TABLE gold.extproductsubcategories
with(
LOCATION = 'extproductsubcategories',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.productsubcategories

CREATE EXTERNAL TABLE gold.extterritories
with(
LOCATION = 'extterritories',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.territories

CREATE EXTERNAL TABLE gold.extproducts
with(
LOCATION = 'extproducts',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.products

CREATE EXTERNAL TABLE gold.extreturns
with(
LOCATION = 'extreturns',
Data_SOURCE= source_gold,
FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.returns

CREATE EXTERNAL TABLE gold.extsales
With(
LOCATION = 'extsales',
DATA_SOURCE = source_gold,
FILE_FORMAT = format_parquet
)
As 
SELECT * FROM gold.sales