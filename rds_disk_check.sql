SET pages 200  
SELECT  
'===========================================================' || CHR(10) ||  
'Total Database Physical Size = ' || ROUND(redolog_size_gib + dbfiles_size_gib + tempfiles_size_gib + archlog_size_gib + ctlfiles_size_gib, 2) || ' GiB' || CHR(10) ||  
'===========================================================' || CHR(10) ||  
' Redo Logs Size : ' || ROUND(redolog_size_gib, 3) || ' GiB' || CHR(10) ||  
' Data Files Size : ' || ROUND(dbfiles_size_gib, 3) || ' GiB' || CHR(10) ||  
' Temp Files Size : ' || ROUND(tempfiles_size_gib, 3) || ' GiB' || CHR(10) ||  
' Archive Log Size : ' || ROUND(archlog_size_gib, 3) || ' GiB' || CHR(10) ||  
' Control Files Size : ' || ROUND(ctlfiles_size_gib, 3) || ' GiB' || CHR(10) ||  
'===========================================================' || CHR(10) ||  
' Used Database Size : ' || used_db_size_gib || ' GiB' || CHR(10) ||  
' Free Database Size : ' || free_db_size_gib || ' GiB' || CHR(10) ||  
' Data Pump Directory Size : ' || dpump_db_size_gib || ' GiB' || CHR(10) ||  
' BDUMP Directory Size : ' || bdump_db_size_gib || ' GiB' || CHR(10) ||  
' ADUMP Directory Size : ' || adump_db_size_gib || ' GiB' || CHR(10) ||  
'===========================================================' || CHR(10) ||  
'Total Size (including Dump and Log Files) = ' || ROUND(ROUND(redolog_size_gib, 2) + ROUND(dbfiles_size_gib, 2) + ROUND(tempfiles_size_gib, 2) + ROUND(archlog_size_gib, 2) + ROUND(ctlfiles_size_gib, 2) + ROUND(adump_db_size_gib, 2) + ROUND(dpump_db_size_gib, 2) + ROUND(bdump_db_size_gib, 2), 2) || ' GiB' || CHR(10) ||  
'===========================================================' AS summary  
FROM (SELECT sys_context('USERENV', 'DB_NAME')  
db_name,  
(SELECT SUM(bytes) / 1024 / 1024 / 1024 redo_size  
FROM (SELECT bytes FROM v$log UNION ALL SELECT bytes FROM v$standby_log))  
redolog_size_gib,  
(SELECT SUM(bytes) / 1024 / 1024 / 1024 data_size  
FROM dba_data_files)  
dbfiles_size_gib,  
(SELECT NVL(SUM(bytes), 0) / 1024 / 1024 / 1024 temp_size  
FROM dba_temp_files)  
tempfiles_size_gib,  
(SELECT ROUND(SUM(filesize) / 1024 / 1024 / 1024, 3)  
FROM TABLE(rdsadmin.rds_file_util.listdir('ARCHIVELOG_DIR')))  
archlog_size_gib,  
(SELECT SUM(block_size * file_size_blks) / 1024 / 1024 / 1024  
controlfile_size  
FROM v$controlfile)  
ctlfiles_size_gib,  
ROUND(SUM(used.bytes) / 1024 / 1024 / 1024, 3)  
db_size_gib,  
ROUND(SUM(used.bytes) / 1024 / 1024 / 1024, 3) - ROUND(  
free.f / 1024 / 1024 / 1024)  
used_db_size_gib,  
ROUND(free.f / 1024 / 1024 / 1024, 3)  
free_db_size_gib,  
(SELECT ROUND(SUM(filesize) / 1024 / 1024 / 1024, 3)  
FROM TABLE(rdsadmin.rds_file_util.listdir('BDUMP')))  
bdump_db_size_gib,  
(SELECT ROUND(SUM(filesize) / 1024 / 1024 / 1024, 3)  
FROM TABLE(rdsadmin.rds_file_util.listdir('ADUMP')))  
adump_db_size_gib,  
(SELECT ROUND(SUM(filesize) / 1024 / 1024 / 1024, 3)  
FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')))  
dpump_db_size_gib  
FROM (SELECT bytes  
FROM v$datafile  
UNION ALL  
SELECT bytes  
FROM v$tempfile) used,  
(SELECT SUM(bytes) AS f  
FROM dba_free_space) free  
GROUP BY free.f);
