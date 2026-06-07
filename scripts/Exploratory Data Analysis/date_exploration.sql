-- Date of first and last order & years of sales
SELECT 
MIN(order_date) first_order_date, 
MAX(order_date) last_order_date, 
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find youngest & oldest customer
SELECT 
MIN(birthdate) oldest_birthdate,  
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) youngest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;