-- Phase_8: Stored Procedures
USE production_lb;

DROP PROCEDURE IF EXISTS sp_create_orders;

DELIMITER //

CREATE PROCEDURE sp_create_orders(
    IN p_customer_id BIGINT UNSIGNED,
    IN p_product_id BIGINT UNSIGNED,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(12,2); -- here it is temporary varialbe using DECLARE   
    DECLARE v_stock INT; -- here it is temporary varialbe using DECLARE
    DECLARE v_is_active BOOLEAN; -- here it is temporary varialbe using DECLARE
    DECLARE v_exists INT DEFAULT 0; -- here it is temporary varialbe using DECLARE
    DECLARE v_order_id BIGINT UNSIGNED; -- here it is temporary varialbe using DECLARE

    -- rollback the entire transaction if any sql error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- VALIDATE THE CUSTOMER
    SELECT COUNT(*) INTO v_exists FROM customers WHERE customer_id=p_customer_id;
    IF v_exists=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exists';
    END IF;

    SELECT COUNT(*) INTO v_exists FROM products WHERE product_id=p_product_id;
    IF v_exists=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product does not exist';
    END IF;

    SELECT price,is_active into v_price, v_is_active FROM products WHERE product_id=p_product_id FOR UPDATE;
    
    IF v_is_active = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product is inactive';
    END IF;

    -- VALIDATE QUANTITY
    IF p_quantity<=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantity must be greater than zero';
    END IF;

    -- LOCK INVENTORY SO CONCURRENT ORDERS CANNOT OVERSELL STOCK
    SELECT quantity INTO v_stock FROM inventory WHERE product_id=p_product_id FOR UPDATE; 
    -- FOR UPDATE to lock the row. This prevents race conditions (two people buying the last item at the exact same millisecond).

    IF v_stock<p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insufficient inventory';
    END IF;

    -- CREATE THE ORDER
    INSERT INTO orders(customer_id,order_status,total_amount,created_at)
    VALUES (p_customer_id,'CONFIRMED',v_price*p_quantity,NOW());
    SET v_order_id=LAST_INSERT_ID();

    -- Create the order item
    INSERT INTO order_items (
        order_id,
        product_id,
        quantity,
        unit_price
    )
    VALUES (
        v_order_id,
        p_product_id,
        p_quantity,
        v_price
    );

    -- Reduce stock
    UPDATE inventory
    SET quantity = quantity - p_quantity,
        updated_at = NOW()
    WHERE product_id = p_product_id;

    COMMIT;

    SELECT
        v_order_id AS order_id,
        p_customer_id AS customer_id,
        p_product_id AS product_id,
        p_quantity AS quantity,
        v_price * p_quantity AS total_amount,
        'CONFIRMED' AS order_status;
END//
DELIMITER ;

SHOW PROCEDURE STATUS WHERE Db='production_lb';

-- Check the starting stock
SELECT product_id, product_name, is_active
FROM products
WHERE product_id = 2;

SELECT * FROM inventory
WHERE product_id = 2;

-- Create an order for 2 units of product 2
CALL sp_create_orders(1, 2, 2);

-- What you learned
-- - Stored procedure: packages reusable SQL logic.
-- - Transaction: ensures the order and inventory update succeed together.
-- - FOR UPDATE: locks relevant rows while the transaction checks and updates them.
-- - Error handler: rolls back the transaction when a SQL error occurs.
-- - SIGNAL: raises a clear error when validation fails.