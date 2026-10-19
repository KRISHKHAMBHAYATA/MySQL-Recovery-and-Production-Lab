# MySQL Recovery & Production Lab

A hands-on MySQL DBA portfolio project demonstrating database administration, performance tuning, transaction safety, auditing, security, and recovery concepts.

## Topics Covered

- Relational schema design, keys, constraints, and indexes
- SQL reports and data consistency checks
- Query analysis using `EXPLAIN`
- Transactions, `COMMIT`, `ROLLBACK`, and row locking
- Stored procedures and inventory validation
- Audit triggers
- Database users and least-privilege permissions
- Logical backups and restore verification
- Selective recovery from a backup
- Binary-log and replication diagnostics
- Database monitoring and troubleshooting

## Project Structure

SQL scripts are organized by learning step. Each script demonstrates a specific MySQL DBA concept.

## Requirements

- MySQL Server
- MySQL command-line client
- `mysqldump` for backup exercises

## Running the Scripts

Review each SQL file before executing it. Most scripts assume a database named `production_lb`.

For example, from PowerShell:

```powershell
Get-Content ".\01_schemas.sql" -Raw | mysql -u root -p production_lb
```

Run scripts in the appropriate order and check the results before proceeding.

## Safety Notes

- Use a local practice database, not a production database.
- Review destructive statements before running scripts.
- Do not commit passwords, credentials, private data, or database backup files.
- Replication and point-in-time recovery require additional configuration and validation.

## Project Status

Learning lab for practising MySQL DBA workflows. Features should be considered verified only after their corresponding tests have been executed successfully.