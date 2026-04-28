--Check for nulls or duplicates in primary key
--Expectation: No result
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check unwanted spaces
--Expectation: No result
SELECT cst_lastname FROM bronze.crm_cust_info -- check all other columns too
WHERE cst_lastname != TRIM(cst_lastname);


--Data standardization & consistency
SELECT  DISTINCT cst_gndr -- check other columns as well
FROM bronze.crm_cust_info;

-- Final table:
PRINT '>> Truncating table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT '>> Inserting Data into silver.crm_cust_info';
INSERT INTO silver.crm_cust_info (
	cst_id, 
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
SELECT 
	cst_id, 
	cst_key, 
	TRIM(cst_firstname) as cst_firstname, 
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END cst_gndr,
	cst_create_date
	FROM (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	)t 
	WHERE flag_last = 1;


------------------------------------
--Check the silver table

--Check for nulls or duplicates in primary key
--Expectation: No result
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check unwanted spaces
--Expectation: No result
SELECT cst_lastname FROM silver.crm_cust_info -- check all other columns too
WHERE cst_lastname != TRIM(cst_lastname);


--Data standardization & consistency
SELECT  DISTINCT cst_gndr -- check other columns as well
FROM silver.crm_cust_info;