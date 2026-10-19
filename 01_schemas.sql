USE production_lb;

-- 1.Customers
CREATE TABLE customers(
    customer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. PRODUCTS
CREATE TABLE products(
    product_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_product_price CHECK (price>0)
);

-- 3. INVENTORY
CREATE TABLE inventory(
    product_id BIGINT UNSIGNED PRIMARY KEY,
    quantity INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL 
        DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product FOREIGN KEY(product_id) REFERENCES products(product_id),
    CONSTRAINT chk_inventory_quantity CHECK (quantity >=0)
);

-- 4.ORDERS
CREATE TABLE orders(
    order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    order_status ENUM(
        'PENDING',
        'CONFIRMED',
        'SHIPPED',
        'COMPLETED',
        'CANCELLED'    
    ) NOT NULL DEFAULT 'PENDING',
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_order_total CHECK (total_amount>=0),
    INDEX idx_orders_customers (customer_id),
    INDEX idx_orders_created (created_at),
    INDEX idx_orders_status_created(order_status,created_at)
);

-- 5.ORDER_ITEMS
CREATE TABLE order_items(
    order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_item_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_item_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_item_quantity CHECK (quantity>0),
    CONSTRAINT chk_item_price CHECK (unit_price>=0),
    UNIQUE KEY uq_order_product (order_id,product_id),
    INDEX idx_items_products (product_id),
);

-- 6.Payments
CREATE TABLE payments(
    payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    transaction_ref VARCHAR(100) NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL,
    payment_status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED',
        'REFUNDED'
    ) NOT NULL DEFAULT 'PENDING',
    paid_at DATETIME NULL,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT chk_payment_amount CHECK (payment_amount>0),
    INDEX idx_payments_orders_status (order_id,payment_status),
);

-- 7.inventory_movements
CREATE TABLE inventory_movements(
    movement_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity_change INT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_movements_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_movement_nonzero CHECK (quantity_change<>0),
    INDEX idx_movements_product_date(product_id,created_at)
);

-- 8. audit_logs
CREATE TABLE audit_logs(
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(64) NOT NULL,
    record_id BIGINT UNSIGNED NOT NULL,
    action_type ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    details JSON NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_table_record (table_name,record_id),
    INDEX idx_audit_changes_at (changed_at)
);