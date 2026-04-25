/*
---------------------------------------------------
CREATE DATABASE & SCHEMAS
---------------------------------------------------
Purpose:
	This script creates a new database named 'DataWarehouse' after checking it already exists.
	If it exists, it is dropped & recreated.
	The Script then sets up 3 schemas within the database: bronze, silver & gold
---------------------------------------------------
Warning:
	ALl data in database will be permanently deleted when database is dropped.
---------------------------------------------------
*/

USE MASTER;
GO

--Drop & recreate database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

