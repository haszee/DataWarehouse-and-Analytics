-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Find the total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Find average number of items per order
SELECT SUM(quantity)/COUNT(DISTINCT order_number) AS avg_quantity FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(DISTINCT product_id) AS total_products FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS customers_ordered FROM gold.fact_sales;

-- Generate a report that shows all key metrics
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total # of Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Average Quantity per Order', SUM(quantity)/COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total # of Products', COUNT(DISTINCT product_id) FROM gold.dim_products
UNION ALL
SELECT 'Total # of Customers',  COUNT(DISTINCT customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Total # of Customers Who Have Placed an Order', COUNT(DISTINCT customer_key) FROM gold.fact_sales;