--Data standardization & consistency
SELECT  DISTINCT cntry -- check other columns as well
FROM bronze.erp_loc_a101;


--Final Table
PRINT '>> Truncating table: silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>> Inserting Data into silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT 
	REPLACE (cid, '-', '') cid,
	CASE WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101;


-------------------------------------
--Check Silver layer table

--Data standardization & consistency
SELECT  DISTINCT cntry -- check other columns as well
FROM silver.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;