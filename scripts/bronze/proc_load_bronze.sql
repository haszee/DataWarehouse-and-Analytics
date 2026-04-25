
/*
=================================================================
DDL Script: Insert info into Bronze Layer Tables
=================================================================
Purpose: 
	Truncates existing bronze tables before loading data
	Loads data into bronze layer tables from external csv files via 'BULK INSERT'
	Gets loading time for each table and the whole batch
	Catches error and prints error statement

	PARAMETERS: NONE

	USAGE EXAMPLE: 
		EXEC bronze.load_bronze;
=================================================================
*/

EXEC bronze.load_bronze

GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @end_batch_time DATETIME;
	
	BEGIN TRY
		SET @start_batch_time = GETDATE();
		PRINT '==========================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==========================================';

		PRINT '------------------------------------------';
		PRINT 'Loading CRM Tables'
		PRINT '------------------------------------------';
		
		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.crm_cust_info' 
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT 'INSERTING Data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.crm_cust_info; 
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		
		PRINT '------------------------------------------------------------------------------';
		
		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT 'INSERTING Data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.crm_prd_info; 

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		
		PRINT '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT 'INSERTING Data into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.crm_sales_details; 
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

		PRINT '=======================================================================';

		PRINT '------------------------------------------';
		PRINT 'Loading ERP Tables'
		PRINT '------------------------------------------';
		
		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT 'INSERTING Data into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.erp_cust_az12; 

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		
		PRINT '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.erp_loc_a101' 
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT 'INSERTING Data into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.erp_loc_a101; 

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		
		PRINT '------------------------------------------------------------------------------';

		SET @start_time = GETDATE();

		PRINT 'Truncating Table: bronze.erp_px_cat_g1v2' 
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT 'INSERTING Data into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Hasnain\Documents\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
	
		PRINT '============================================================================';

		SET @end_batch_time = GETDATE();
		PRINT 'Loading of Bronze Layer is Completed';
		PRINT '>> Load Duration of BATCH: ' + CAST(DATEDIFF(second,@start_batch_time,@end_batch_time) AS NVARCHAR) + ' seconds';
	END TRY
	

	BEGIN CATCH
		PRINT '======================================';
		PRINT 'ERROR LOADING BRONZE LAYER';
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Message:' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message:' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '======================================';
	END CATCH
END