-- Check Files List Diretory on DATA_PUMP_DIR --
SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')) ORDER BY MTIME desc;

-- Download Files From S3 to DATA_PUMP_DIR --
SELECT rdsadmin.rdsadmin_s3_tasks.download_from_s3(
      p_bucket_name    =>  'datapumpfile',
      p_s3_prefix => 'VET_MX76_PROD_SERCO_1_12082024.dmp',
      p_directory_name =>  'DATA_PUMP_DIR')
AS TASK_ID FROM DUAL;

-- Upload Files From DATA_PUMP_DIR to S3 --
SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
      p_bucket_name    =>  'datapumpfile',
      p_s3_prefix => 'MAXTST_08192024_imp.log',
      p_directory_name =>  'DATA_PUMP_DIR')
AS TASK_ID FROM DUAL;

-- Run This Command After Run Download or Upload --
SELECT text FROM table(rdsadmin.rds_file_util.read_text_file('BDUMP','dbtask-1724075585572-63.log'));
