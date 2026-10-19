
USE production_lb;

-- 1. Insert products
INSERT INTO products (product_name, price)
VALUES
('Laptop', 65000.00),
('Keyboard', 1500.00),
('Mouse', 800.00),
('Monitor', 12000.00),
('Headphones', 3000.00),
('Webcam', 2500.00),
('SSD 1TB', 7500.00),
('USB Hub', 1200.00);

-- 2. Insert inventory
INSERT INTO inventory (product_id, quantity)
SELECT product_id,
       CASE product_name
           WHEN 'Laptop' THEN 15
           WHEN 'Keyboard' THEN 100
           WHEN 'Mouse' THEN 8
           WHEN 'Monitor' THEN 25
           WHEN 'Headphones' THEN 4
           WHEN 'Webcam' THEN 30
           WHEN 'SSD 1TB' THEN 12
           WHEN 'USB Hub' THEN 0
       END
FROM products
WHERE product_name IN (
    'Laptop', 'Keyboard', 'Mouse', 'Monitor',
    'Headphones', 'Webcam', 'SSD 1TB', 'USB Hub'
);

-- 3. Insert customers
INSERT INTO customers (full_name, email)
VALUES
('Aarav Patel', 'aarav@example.com'),
('Diya Shah', 'diya@example.com'),
('Rohan Mehta', 'rohan@example.com'),
('Anaya Desai', 'anaya@example.com'),
('Kabir Joshi', 'kabir@example.com'),
('Ishita Trivedi', 'ishita@example.com'),
('Vivaan Shah', 'vivaan@example.com'),
('Sara Patel', 'sara@example.com'),
('Arjun Mehta', 'arjun@example.com'),
('Mira Desai', 'mira@example.com');

-- 4. Insert orders
INSERT INTO orders (customer_id, order_status, total_amount, created_at)
VALUES
(1, 'COMPLETED', 66500.00, '2026-10-01 10:00:00'),
(2, 'COMPLETED', 1500.00, '2026-10-02 11:30:00'),
(3, 'CONFIRMED', 12000.00, '2026-10-03 14:00:00'),
(4, 'PENDING', 3000.00, '2026-10-04 09:15:00'),
(5, 'CANCELLED', 800.00, '2026-10-05 16:20:00'),
(6, 'COMPLETED', 7500.00, '2026-10-06 12:45:00'),
(7, 'SHIPPED', 2500.00, '2026-10-07 15:10:00'),
(8, 'PENDING', 1200.00, '2026-10-08 17:00:00'),
(9, 'COMPLETED', 3000.00, '2026-10-09 13:30:00'),
(10, 'CONFIRMED', 13000.00, '2026-10-10 10:45:00');

-- 5. Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 65000.00),
(1, 2, 1, 1500.00),
(2, 2, 1, 1500.00),
(3, 4, 1, 12000.00),
(4, 5, 1, 3000.00),
(5, 3, 1, 800.00),
(6, 7, 1, 7500.00),
(7, 6, 1, 2500.00),
(8, 8, 1, 1200.00),
(9, 5, 1, 3000.00),
(10, 4, 1, 12000.00),
(10, 3, 1, 800.00);

-- 6. Insert payments
INSERT INTO payments
    (order_id, transaction_ref, payment_amount, payment_status, paid_at)
VALUES
(1, 'TXN-1001', 66500.00, 'SUCCESS', '2026-10-01 10:05:00'),
(2, 'TXN-1002', 1500.00, 'SUCCESS', '2026-10-02 11:35:00'),
(3, 'TXN-1003', 12000.00, 'PENDING', NULL),
(4, 'TXN-1004', 3000.00, 'PENDING', NULL),
(5, 'TXN-1005', 800.00, 'FAILED', NULL),
(6, 'TXN-1006', 7500.00, 'SUCCESS', '2026-10-06 12:50:00'),
(7, 'TXN-1007', 2500.00, 'SUCCESS', '2026-10-07 15:15:00'),
(9, 'TXN-1009', 3000.00, 'SUCCESS', '2026-10-09 13:35:00'),
(10, 'TXN-1010', 12800.00, 'SUCCESS', '2026-10-10 10:50:00');

-- 7. Insert inventory movements
INSERT INTO inventory_movements
    (product_id, quantity_change, reason)
VALUES
(1, 20, 'Initial stock'),
(2, 150, 'Initial stock'),
(3, 50, 'Initial stock'),
(4, 40, 'Initial stock'),
(5, 30, 'Initial stock'),
(6, 40, 'Initial stock'),
(7, 25, 'Initial stock'),
(8, 20, 'Initial stock');

-- 8. Verify row counts
SELECT 'customers' AS table_name, COUNT(*) AS total FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'inventory_movements', COUNT(*) FROM inventory_movements
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs;
