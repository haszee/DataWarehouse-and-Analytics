--Check for nulls or duplicates in primary key
--Expectation: No result
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--Check unwanted spaces
--Expectation: No result
SELECT prd_key FROM bronze.crm_prd_info -- check all other columns too
WHERE prd_key != TRIM(prd_key);

--Check for NULLs or Negative numbers
--Expectation: No result
SELECT prd_cost FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

--Data standardization & consistency
SELECT  DISTINCT prd_key -- check other columns as well
FROM bronze.crm_prd_info;

--Check Invalid Start/End Date Order: there must be start date, end date cannot be before start date & dates cannot overlap for things like prices in different years
--Solution: Use start date - 1 day for next entry as end date
SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Final table:
PRINT '>> Truncating table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;
PRINT '>> Inserting Data into silver.crm_prd_info';
INSERT INTO silver.crm_prd_info (
	prd_id, 
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT 
	prd_id, 
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;


------------------------------------
--Check the silver table

--Check for nulls or duplicates in primary key
--Expectation: No result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--Check unwanted spaces
--Expectation: No result
SELECT prd_key FROM silver.crm_prd_info -- check all other columns too
WHERE prd_key != TRIM(prd_key);


--Data standardization & consistency
SELECT  DISTINCT prd_key -- check other columns as well
FROM silver.crm_prd_info;

--Check for NULLs or Negative numbers
--Expectation: No result
SELECT prd_cost FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

--Check Invalid Start/End Date Order
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--Check final table
SELECT * FROM silver.crm_prd_info;