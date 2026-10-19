-- One important production consideration: these triggers do not record the authenticated application user or client IP. 
-- Also, a database administrator with sufficient privileges may be able to alter the triggers or audit records. 
-- For a stronger production audit system, restrict access to the audit table and use a carefully designed identity and retention policy.


use production_lb;

-- RECORD NEWLY INSERTED ORDERS
DROP TRIGGER IF EXISTS trg_orders_after_insert;

DELIMITER //
CREATE TRIGGER trg_orders_after_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name,record_id,action_type,details)
    VALUES ('orders',NEW.order_id,'INSERT',JSON_OBJECT('new_status',NEW.order_status,
                                                       'total_amount',NEW.total_amount,
                                                       'customer_id',NEW.customer_id)
            );
END//

-- RECORD ORDER UPDATES

DROP TRIGGER IF EXISTS trg_orders_after_update;

CREATE TRIGGER trg_orders_after_update 
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name,record_id,action_type,details)
    VALUES ('orders',NEW.order_id,'UPDATE',JSON_OBJECT(
                                                        'old_status',OLD.order_status,
                                                        'new_status',NEW.order_status,
                                                        'old_total',OLD.total_amount,
                                                        'new_total',NEW.total_amount
            )
    );
END//

-- RECORD ORDER DELETIONS

DROP TRIGGER IF EXISTS trg_orders_after_delete;

CREATE TRIGGER trg_orders_after_delete
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name,record_id,action_type,details)
    VALUES 
        ('orders',OLD.order_id,'DELETE',JSON_OBJECT(
                                                    'old_status',OLD.order_status,
                                                    'old_total',OLD.total_amount,
                                                    'customer_id',OLD.customer_id)
        );
END//

DELIMITER ;

-- SHOW TRIGGERS;

START TRANSACTION;

UPDATE orders
SET total_amount = total_amount + 1
WHERE order_id = 1;

SELECT *
FROM audit_logs
WHERE table_name = 'orders'
  AND record_id = 1
ORDER BY audit_id DESC;

ROLLBACK;

SELECT *
FROM orders
WHERE order_id = 1;

SELECT *
FROM audit_logs
WHERE table_name = 'orders'
  AND record_id = 1
ORDER BY audit_id DESC;

SELECT action_type,COUNT(*) AS total_events FROM audit_logs GROUP BY action_type;