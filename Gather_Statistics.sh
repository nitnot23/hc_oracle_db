#!/bin/bash
source /home/oracle/db_profile; export NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS';
$ORACLE_HOME/bin/sqlplus system/oracle123 << EOF
SET TIME ON TIMING ON ECHO ON;
SPOOL /home/oracle/mii/scripts/gather_`date +%T%m%d`.log
exec dbms_stats.gather_schema_stats(ownname => 'UPF_ADMIN', estimate_percent => 20);
SPOOL OFF;
EXIT;
EOF
