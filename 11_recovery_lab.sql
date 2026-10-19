use production_lb;

CREATE TABLE IF NOT EXISTS recovery_lab(
    record_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    account_balanace DECIMAL(12,2) NOT NULL
);

INSERT INTO recovery_lab(record_id,customer_name,account_balanace)
VALUES 
    (1,'Customer A',1500.00),
    (2,'Customer B',2750.00),
    (3,'Customer C',4200.00)
ON DUPLICATE KEY UPDATE
    customer_name=VALUES(customer_name);

