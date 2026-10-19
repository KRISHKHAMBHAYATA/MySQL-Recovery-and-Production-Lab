
USE production_lb;

-- 1. Confirm the database exists
SHOW DATABASES LIKE 'production_lb';

-- 2. Verify all project tables
SHOW TABLES;

-- 3. Check key table row counts
SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs;

-- 4. Confirm stored procedure exists
SHOW PROCEDURE STATUS
WHERE Db = 'production_lb';

-- 5. Confirm triggers exist
SHOW TRIGGERS FROM production_lb;

-- 6. Inspect indexes on important tables
SHOW INDEX FROM orders;
SHOW INDEX FROM order_items;

-- 7. Inspect database engine and table sizes
SELECT
    table_name,
    engine,
    table_rows,
    ROUND((data_length + index_length) / 1024, 2) AS size_kb
FROM information_schema.tables
WHERE table_schema = 'production_lb'
ORDER BY table_name;

-- 8. Check for order-total inconsistencies
SELECT
    o.order_id,
    o.total_amount AS recorded_total,
    SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(oi.quantity * oi.unit_price);
