USE production_lb;

CREATE TABLE IF NOT EXISTS transaction_lab_inventory(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT chk_lab_quantity CHECK (quantity>=0)
) ENGINE=InnoDB;

INSERT INTO transaction_lab_inventory (product_id,product_name,quantity)
VALUES
    (1,'Lab Laptop',100),
    (2,'Lab Mouse',50)
ON DUPLICATE KEY UPDATE
    product_name=VALUES(product_name);

SELECT * FROM transaction_lab_inventory;

-- START TRANSACTION;

-- UPDATE transaction_lab_inventory SET quantity=quantity-10 WHERE product_id=1 AND quantity>=10;

-- SELECT * FROM transaction_lab_inventory WHERE product_id=1;

-- ROLLBACK;

-- SELECT * FROM transaction_lab_inventory WHERE product_id=1;

-- START TRANSACTION;

-- UPDATE transaction_lab_inventory SET quantity=quantity-5 WHERE product_id=1 AND quantity>=5;

-- SELECT ROW_COUNT() AS rows_affected;

-- COMMIT;

-- SELECT * FROM  transaction_lab_inventory WHERE product_id=1;





-- LOCKING

START TRANSACTION; -- TRANSACTION A

UPDATE transaction_lab_inventory SET quantity=quantity-1 WHERE product_id=2;

ROLLBACK;

START TRANSACTION; -- TRANSACTION B

UPDATE transaction_lab_inventory SET quantity=quantity-2 WHERE product_id=2;

COMMIT;

-- DBA lesson: InnoDB row locks protect concurrent updates, but long-running transactions can block other work. 
-- Keep transactions short, 
-- and investigate the blocking 
-- session before deciding whether to terminate it.