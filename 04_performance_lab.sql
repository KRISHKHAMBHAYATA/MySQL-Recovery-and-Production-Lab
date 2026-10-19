USE production_lb;

SHOW INDEX FROM orders;
SHOW INDEX FROM customers;
SHOW INDEX FROM order_items;

SHOW CREATE TABLE orders;


-- A. Query applies a function to the indexed date column
EXPLAIN
SELECT order_id, created_at, total_amount
FROM orders
WHERE YEAR(created_at) = 2026;


-- B. Equivalent date-range query
EXPLAIN
SELECT order_id, created_at, total_amount
FROM orders
WHERE created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';


-- C. Filter by order status and date
EXPLAIN
SELECT order_id, order_status, created_at, total_amount
FROM orders
WHERE order_status = 'COMPLETED'
  AND created_at >= '2026-01-01'
  AND created_at <  '2027-01-01';


-- D. Inspect the current query-plan statistics
ANALYZE TABLE orders;

-- E. Inspect table index definitions
SHOW INDEX FROM orders;

EXPLAIN
SELECT product_id, product_name, price
FROM products
WHERE product_name = 'Laptop';