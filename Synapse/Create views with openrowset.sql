CREATE Schema gold

CREATE VIEW gold.calendar AS SELECT * FROM OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Calendar/', FORMAT = 'PARQUET') Query1 GO
CREATE VIEW gold.customer AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Customers/', FORMAT = 'PARQUET') Query2 GO
CREATE VIEW gold.productcategories AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Product_Categories/', FORMAT = 'PARQUET') Query3 GO
CREATE VIEW gold.productsubcategories AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Product_SubCategories/', FORMAT = 'PARQUET') Query4 GO
CREATE VIEW gold.territories AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Territories/', FORMAT = 'PARQUET') Query5 GO
CREATE VIEW gold.products AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Products/', FORMAT = 'PARQUET') Query6 GO
CREATE VIEW gold.returns AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdventureWorks_Returns/', FORMAT = 'PARQUET') Query7 GO
CREATE VIEW gold.sales AS Select * from OPENROWSET(BULK 'https://awstoragedatalake11.dfs.core.windows.net/silver/AdeventureWorks_Sales/', FORMAT = 'PARQUET') Query8

