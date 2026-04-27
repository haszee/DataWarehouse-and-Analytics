--Check if any prd_key & cust_id are missing to check if you can join
SELECT * FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

--Check invalid dates
SELECT sls_order_dt FROM bronze.crm_sales_details --check the others too
WHERE 
	sls_order_dt <= 0 
	OR LEN(sls_order_dt) != 8 --8 b/c they look like 20260129
	OR sls_order_dt > 20500101 --date range boundaries
	OR sls_order_dt < 19000101; 

-- Check Order date < Shipping date < Due Date
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt;

--Check if Sales (total dollar amount) is Negative, 0 or Null
SELECT DISTINCT
	sls_sales,
	sls_quantity,	
	sls_price
FROM bronze.crm_sales_details
WHERE 
	sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_sales <= 0
	OR sls_quantity IS NULL OR sls_quantity <= 0
	OR sls_price IS NULL OR sls_price <= 0


--Final Table:
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details;

-------------------------------------------------------------------------
--Check Silver tables

--Check if any prd_key & cust_id are missing to check if you can join
SELECT * FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

--Check invalid dates
SELECT sls_order_dt FROM silver.crm_sales_details --check the others too
WHERE 
	sls_order_dt IS NULL
	OR LEN(sls_order_dt) != 8 --8 b/c they look like 20260129
	OR sls_order_dt > '2050-01-01' --date range boundaries
	OR sls_order_dt < '1900-01-01'; 

-- Check Order date < Shipping date < Due Date
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt;

--Check if Sales (total dollar amount) is Negative, 0 or Null
SELECT DISTINCT
	sls_sales,
	sls_quantity,	
	sls_price
FROM silver.crm_sales_details
WHERE 
	sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_sales <= 0
	OR sls_quantity IS NULL OR sls_quantity <= 0
	OR sls_price IS NULL OR sls_price <= 0

SELECT * FROM silver.crm_sales_details;