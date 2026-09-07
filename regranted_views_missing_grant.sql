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
FROM all_views v
LEFT JOIN all_tab_privs p
       ON p.table_schema = v.owner
      AND p.table_name   = v.view_name
      AND p.grantee      = 'MAXIMO_READ_ONLY'
      AND p.privilege    = 'SELECT'
WHERE v.owner = 'MAXIMO'
  AND p.table_name IS NULL
ORDER BY v.view_name;

-- One executable script that finds only the MAXIMO views currently missing SELECT on MAXIMO_READ_ONLY and grants them automatically
BEGIN
    FOR v IN (
        SELECT v.owner,
               v.view_name
        FROM all_views v
        LEFT JOIN all_tab_privs p
               ON p.table_schema = v.owner
              AND p.table_name   = v.view_name
              AND p.grantee      = 'MAXIMO_READ_ONLY'
              AND p.privilege    = 'SELECT'
        WHERE v.owner = 'MAXIMO'
          AND p.table_name IS NULL
        ORDER BY v.view_name
    )
    LOOP
        EXECUTE IMMEDIATE
            'GRANT SELECT ON "' || v.owner || '"."' || v.view_name ||
            '" TO MAXIMO_READ_ONLY';

        DBMS_OUTPUT.PUT_LINE(
            'Granted SELECT on ' || v.owner || '.' || v.view_name
        );
    END LOOP;
END;
/
