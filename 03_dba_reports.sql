
USE production_lb;

-- REPORT 1: Revenue by order status
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_order_value
FROM orders
GROUP BY order_status
ORDER BY total_order_value DESC;


-- REPORT 2: Revenue from completed orders with successful payments
SELECT
    SUM(o.total_amount) AS completed_order_value,
    SUM(p.payment_amount) AS successful_payment_value
FROM orders o
JOIN payments p ON p.order_id = o.order_id
WHERE o.order_status = 'COMPLETED'
  AND p.payment_status = 'SUCCESS';


-- REPORT 3: Customers and their order counts
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_order_value
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_order_value DESC;


-- REPORT 4: Low-stock products
SELECT
    p.product_id,
    p.product_name,
    i.quantity
FROM products p
JOIN inventory i ON i.product_id = p.product_id
WHERE i.quantity <= 10
ORDER BY i.quantity ASC;


-- REPORT 5: Orders without a successful payment
SELECT
    o.order_id,
    o.order_status,
    o.total_amount,
    p.payment_status
FROM orders o
LEFT JOIN payments p ON p.order_id = o.order_id
WHERE o.order_status IN ('CONFIRMED', 'SHIPPED', 'COMPLETED')
  AND (p.payment_id IS NULL OR p.payment_status <> 'SUCCESS');


-- REPORT 6: Find order-total inconsistencies
SELECT
    o.order_id,
    o.total_amount AS recorded_total,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS calculated_total
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> calculated_total;


-- REPORT 7: Products never ordered
SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;


-- REPORT 8: Duplicate customer emails
SELECT
    email,
    COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


-- REPORT 9: Daily order trends
SELECT
    DATE(created_at) AS order_date,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS order_value
FROM orders
GROUP BY DATE(created_at)
ORDER BY order_date;


-- REPORT 10: Audit-log activity
SELECT
    table_name,
    action_type,
    COUNT(*) AS total_changes
FROM audit_logs
GROUP BY table_name, action_type
ORDER BY total_changes DESC;


-- Report	:What a DBA learns
-- Revenue by status:	How orders are distributed across states
-- Successful payments:	Whether completed orders have matching successful payments
-- Customer orders:	Which customers have the most orders
-- Low stock:	Which products may need restocking
-- Missing/failed payments:	Which orders need payment investigation
-- Order-total mismatch:	Whether stored totals match order-item calculations
-- Products never ordered:	Which products have no recorded sales
-- Duplicate emails:	Whether customer data contains duplicates
-- Daily trends:	How order volume changes over time
-- Audit activity:	Which changes are recorded by the audit system
-- Important: These reports identify potential inconsistencies; they don't automatically prove fraud or a database failure. For example, an order without a successful payment may simply be pending.