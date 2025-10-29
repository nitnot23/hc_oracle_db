1) re-create directories

EXEC rdsadmin.rdsadmin_master_util.drop_onlinelog_dir;

exec rdsadmin.rdsadmin_master_util.create_onlinelog_dir;

exec rdsadmin.rdsadmin_master_util.create_archivelog_dir;

2) Re-create redologs

-- add the redo logs the first (example : 1G)
exec rdsadmin.rdsadmin_util.add_logfile(p_size => '128M');

-- monitor online redo log status to drop INACTIVE logs

EXEC rdsadmin.rdsadmin_util.switch_logfile;

exec rdsadmin.rdsadmin_util.checkpoint;

select group#, bytes/1024/1024 mb, status from v$log;

SELECT GROUP#, MEMBER, STATUS FROM V$LOGFILE ORDER BY GROUP#, MEMBER;

select * from dba_directories;

show parameter archive

-- drop small log groups when INACTIVE
exec rdsadmin.rdsadmin_util.drop_logfile(grp => 6);
