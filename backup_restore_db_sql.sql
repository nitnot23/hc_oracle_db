-- connect to mysqladmin on prod
-- use MAXPROD/MAXDEV/MAXTEST db
use MAXPROD
go
-- Backup DB to S3 bucket
EXEC msdb.dbo.rds_backup_database
@source_db_name = 'MAXPROD',
@s3_arn_to_backup_to = 'arn:aws:s3:::yyc-prod-manage-db-export-storage/MAXPROD_19082026.bak';
-- to check the progress
EXEC msdb.dbo.rds_task_status @task_id=10;
-- connect to mysqladmin on non-prod
-- In SQL Server Management Studio, Right click database > Delete > Tick 'close existing connections'
-- Restore DB from S3 bucket
exec msdb.dbo.rds_restore_database
@restore_db_name='MAXDEV', --new DB name
@s3_arn_to_restore_from='arn:aws:s3:::yyc-prod-manage-db-export-storage/MAXPROD_19082026.bak';
-- to check the progress
EXEC msdb.dbo.rds_task_status @task_id=5;
-- Run this for SQL Server database before Maximo deployment
ALTER DATABASE MAXDEV 
SET ALLOW_SNAPSHOT_ISOLATION ON;  
ALTER DATABASE MAXDEV  
SET READ_COMMITTED_SNAPSHOT ON;
-- Check MAXIMO user is mapped correctly
use MAXDEV
go
EXEC sp_helpuser 'MAXIMO';
--If LoginName is NULL, then run
ALTER USER [maximo] WITH LOGIN = [MAXIMO];
