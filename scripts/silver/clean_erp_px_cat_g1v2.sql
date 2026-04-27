--Data standardization & consistency
SELECT  DISTINCT id -- check other columns as well
FROM bronze.erp_px_cat_g1v2;

--Check unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat); -- check other columns as well

--Final Table
PRINT '>> Truncating table: silver.erp_px_cat_g1v2';
TRUNCATE TABLE silver.erp_px_cat_g1v2;
PRINT '>> Inserting Data into silver.erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2

----------------------------------------------
-- Check Silver layer table

--Data standardization & consistency
SELECT  DISTINCT id -- check other columns as well
FROM silver.erp_px_cat_g1v2;

--Check unwanted spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat); -- check other columns as well

SELECT * FROM silver.erp_px_cat_g1v2