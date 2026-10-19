USE production_lb;

-- create a restricted application account
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'KRish@2506';

-- Allow the application to the read products and inventory
GRANT SELECT ON production_lb.products TO 'app_user'@'localhost';
GRANT SELECT ON production_lb.inventory TO 'app_user'@'localhost';

-- Allow order creation and updates, but not deleteion
GRANT SELECT,INSERT,UPDATE ON production_lb.orders TO 'app_user'@'localhost';
GRANT SELECT,INSERT ON production_lb.order_items TO 'app_user'@'localhost';

-- Inspect the account permissions
SHOW GRANTS FOR 'app_user'@'localhost';

-- Inspect the databse accounts and their host restrictions
SELECT User,Host FROM mysql.user WHERE User='app_user';

-- Important production lesson
-- - Avoid using the MySQL root account for application connections.
-- - Grant only the permissions an application actually needs.
-- - Do not store real passwords in source-controlled SQL files.
-- - A restricted user cannot automatically execute sp_create_order; 
-- stored procedures need appropriate EXECUTE permissions. We can configure that separately after verifying the procedure and its security context.