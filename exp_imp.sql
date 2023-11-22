-- Export Schema Using Oracle Data Pump --

DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN(
    operation => 'EXPORT', 
    job_mode  => 'SCHEMA', 
    job_name  => null
  );
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl         , 
    filename  => 'MAXPRD_24102023.dmp'   , 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file
  );
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'MAXPRD_24102023_exp.log', 
    directory => 'DATA_PUMP_DIR' , 
    filetype  => dbms_datapump.ku$_file_type_log_file
  );
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''MAXPRD'')');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/

-- Import Schema Using Oracle Data Pump and Remap Schema --
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( 
    operation => 'IMPORT', 
    job_mode  => 'SCHEMA', 
    job_name  => null);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'VETMXPRD_22112023.dmp', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'VETMXPRE_22112023_imp.log', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_log_file);
  DBMS_DATAPUMP.metadata_remap(
    handle => v_hdnl, 
    name => 'REMAP_SCHEMA', 
    old_value => 'VETMXPRD', 
    value => 'VETMXPRE'); 
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/
