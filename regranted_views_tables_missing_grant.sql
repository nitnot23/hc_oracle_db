-- Check all privs and role in a user
SELECT 'ROLE' AS privilege_type,
       granted_role AS privilege,
       NULL AS owner,
       NULL AS object_name
FROM dba_role_privs
WHERE grantee = UPPER('EDH_MAXIMO_READ')
UNION ALL
SELECT 'SYSTEM',
       privilege,
       NULL,
       NULL
FROM dba_sys_privs
WHERE grantee = UPPER('EDH_MAXIMO_READ')
UNION ALL
SELECT 'OBJECT',
       privilege,
       owner,
       table_name
FROM dba_tab_privs
WHERE grantee = UPPER('EDH_MAXIMO_READ')
ORDER BY 1, 2, 3, 4;

-- Check the views that are missing the grant
SELECT v.owner,
       v.view_name
FROM dba_views v
LEFT JOIN dba_tab_privs p
       ON p.owner      = v.owner
      AND p.table_name = v.view_name
      AND p.grantee    = 'MAXIMO_READ_ONLY'
      AND p.privilege  = 'SELECT'
WHERE v.owner = 'MAXIMO'
  AND p.table_name IS NULL
ORDER BY v.view_name;

-- One executable script that finds only the MAXIMO views currently missing SELECT on MAXIMO_READ_ONLY and grants them automatically
SET SERVEROUTPUT ON;

DECLARE
    v_sql VARCHAR2(1000);
    v_count NUMBER := 0;
BEGIN
    FOR r IN (
        SELECT v.owner, v.view_name
        FROM dba_views v
        WHERE v.owner = 'MAXIMO'
          AND NOT EXISTS (
              SELECT 1 
              FROM dba_tab_privs p
              WHERE p.owner      = v.owner
                AND p.table_name = v.view_name
                AND p.grantee    = 'MAXIMO_READ_ONLY'
                AND p.privilege  = 'SELECT'
          )
        ORDER BY v.view_name
    )
    LOOP
        v_sql := 'GRANT SELECT ON "' || r.owner || '"."' || r.view_name || '" TO MAXIMO_READ_ONLY';
        
        EXECUTE IMMEDIATE v_sql;
        
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('Granted SELECT on ' || r.owner || '.' || r.view_name);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total views granted: ' || v_count);
END;
/

--------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'ROLE' AS privilege_type,
       granted_role AS privilege,
       NULL AS owner,
       NULL AS object_name
FROM dba_role_privs
WHERE grantee = UPPER('LLE')
UNION ALL
SELECT 'SYSTEM',
       privilege,
       NULL,
       NULL
FROM dba_sys_privs
WHERE grantee = UPPER('LLE')
UNION ALL
SELECT 'OBJECT',
       privilege,
       owner,
       table_name
FROM dba_tab_privs
WHERE grantee = UPPER('LLE')
ORDER BY 1, 2, 3, 4;


SELECT t.owner,
       t.table_name
FROM dba_tables t
LEFT JOIN dba_tab_privs p
       ON p.owner = t.owner
      AND p.table_name   = t.table_name
      AND p.grantee      = 'MAXIMO_READ_ONLY'
      AND p.privilege    = 'SELECT'
WHERE t.owner = 'MAXIMO'
  AND t.table_name NOT LIKE 'DR$%'
  AND p.table_name IS NULL
ORDER BY t.table_name;


SET SERVEROUTPUT ON;

BEGIN
    FOR t IN (
        SELECT a.owner,
               a.table_name
        FROM all_tables a
        WHERE a.owner = 'MAXIMO'
          AND a.table_name NOT LIKE 'DR$%'
          AND NOT EXISTS (
              SELECT 1
              FROM all_tab_privs p
              WHERE p.table_schema = a.owner
                AND p.table_name   = a.table_name
                AND p.grantee      = 'MAXIMO_READ_ONLY'
                AND p.privilege    = 'SELECT'
          )
        ORDER BY a.table_name
    )
    LOOP
        BEGIN
            EXECUTE IMMEDIATE
                'GRANT SELECT ON "' || t.owner || '"."' ||
                t.table_name || '" TO MAXIMO_READ_ONLY';

            DBMS_OUTPUT.PUT_LINE(
                'GRANTED: ' || t.owner || '.' || t.table_name
            );

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(
                    'FAILED: ' || t.owner || '.' || t.table_name ||
                    ' - ' || SQLERRM
                );
        END;
    END LOOP;
END;
/
