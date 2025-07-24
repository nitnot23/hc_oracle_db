-- Export Table Using Oracle Data Pump --

DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN(
    operation => 'EXPORT', 
    job_mode  => 'TABLE', 
    job_name  => null
  );
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'WFASSIGNEMNTS_WFCALLSTjACK_29012024.dmp', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file
  );
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'WFASSIGNEMNTS_WFCALLSTACK_29012024_exp.log', 
    directory => 'DATA_PUMP_DIR' , 
    filetype  => dbms_datapump.ku$_file_type_log_file
  );
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,name => 'SCHEMA_LIST', value => '''MAXPRD''');
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,name => 'NAME_LIST', value => '''WFASSIGNEMNTS'',''WFCALLSTACK''');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/

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

-- Import Table Using Oracle Data Pump --
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( 
    operation => 'IMPORT', 
    job_mode  => 'TABLE', 
    job_name  => null);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'NC_SDS_INSTANCE_24072025.dmp',
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file );
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'NC_SDS_INSTANCE_24072025_imp.log', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_log_file);
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''COGNOS_CS'')');
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'NAME_EXPR','IN (''NC_SDS_INSTANCE'')');
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

-- Import Schema Using Oracle Data Pump, Remap Schema and Remap Tablespace --
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( 
    operation => 'IMPORT', 
    job_mode  => 'SCHEMA', 
    job_name  => null);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'VET_MX76_PROD_SERCO_1_12082024.dmp', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'MAXTST_08192024_imp.log', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_log_file);
  DBMS_DATAPUMP.metadata_remap(
    handle => v_hdnl, 
    name => 'REMAP_SCHEMA', 
    old_value => 'VET_MX76_PROD_SERCO_1', 
    value => 'MAXTST'); 
  DBMS_DATAPUMP.metadata_remap(
    handle => v_hdnl, 
    name => 'REMAP_TABLESPACE', 
    old_value => 'VET_MX76_PROD_SERCO_D', 
    value => 'MAXDATA'); 
  DBMS_DATAPUMP.metadata_remap(
    handle => v_hdnl, 
    name => 'REMAP_TABLESPACE', 
    old_value => 'VET_MX76_PROD_SERCO_T', 
    value => 'MAXTEMP'); 
  DBMS_DATAPUMP.metadata_remap(
    handle => v_hdnl, 
    name => 'REMAP_TABLESPACE', 
    old_value => 'VET_MX76_PROD_SERCO_I', 
    value => 'MAXINDEX'); 
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/
