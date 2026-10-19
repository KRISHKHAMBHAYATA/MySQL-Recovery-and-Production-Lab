
USE production_lb;

-- 1. Server health and uptime
SHOW GLOBAL STATUS LIKE 'Uptime';

-- 2. Connection usage
SHOW GLOBAL STATUS LIKE 'Threads_connected';
SHOW GLOBAL STATUS LIKE 'Max_used_connections';
SHOW VARIABLES LIKE 'max_connections';

-- 3. Running queries and sessions
SHOW FULL PROCESSLIST;

-- 4. InnoDB engine health
SHOW ENGINE INNODB STATUS;

-- 5. Database sizes
SELECT
    table_schema AS database_name,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2)
        AS size_mb
FROM information_schema.tables
WHERE table_schema = 'production_lb'
GROUP BY table_schema;

-- 6. Tables and approximate row counts
SELECT
    table_name,
    table_rows,
    ROUND((data_length + index_length) / 1024, 2) AS size_kb
FROM information_schema.tables
WHERE table_schema = 'production_lb'
ORDER BY data_length + index_length DESC;
