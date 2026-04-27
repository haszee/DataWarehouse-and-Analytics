--Check dates
SELECT bdate FROM bronze.erp_cust_az12
WHERE bdate < '1900-01-01' OR bdate > GETDATE();

--Data standardization & consistency
SELECT  DISTINCT gen -- check other columns as well
FROM bronze.erp_cust_az12;

--Final Table
PRINT '>> Truncating table: silver.erp_cust_az12';
TRUNCATE TABLE silver.erp_cust_az12;
PRINT '>> Inserting Data into silver.erp_cust_az12';
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid,
	CASE WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate, 
	CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

----------------------------------
--Check Silver layer table

SELECT bdate FROM silver.erp_cust_az12
WHERE bdate < '1900-01-01' OR bdate > GETDATE();

SELECT DISTINCT gen FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12