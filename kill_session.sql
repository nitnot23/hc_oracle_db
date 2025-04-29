DECLARE
           sid NUMBER;
           serial NUMBER;
        BEGIN
           SELECT s.sid, s.serial#
             INTO sid, serial
             FROM v$session s
             WHERE s.sid = <session_sid> AND s.serial# = <session_serial#>;
           rdsadmin.rdsadmin_util.disconnect(sid => sid, serial => serial);
        END;
