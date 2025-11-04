SPOOL C:\scripts\count_tabels_prd_2.txt
SET SERVEROUTPUT ON
DECLARE
  v_sql        VARCHAR2(4000);
  v_count      NUMBER;
  v_cursor     INTEGER;
  v_ret        INTEGER;
BEGIN
  FOR t IN (
    SELECT owner, table_name
    FROM all_tables
    WHERE owner = 'MAXIMO'
    ORDER BY table_name
  )
  LOOP
    v_sql := 'SELECT COUNT(*) FROM ' || t.owner || '.' || t.table_name;

    v_cursor := DBMS_SQL.OPEN_CURSOR;
    BEGIN
      DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
      DBMS_SQL.DEFINE_COLUMN(v_cursor, 1, v_count);
      v_ret := DBMS_SQL.EXECUTE(v_cursor);  -- ✅ FIXED LINE
      IF DBMS_SQL.FETCH_ROWS(v_cursor) > 0 THEN
        DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_count);
      END IF;
      DBMS_OUTPUT.PUT_LINE(t.table_name || ': ' || v_count);
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(t.table_name || ': ERROR - ' || SQLERRM);
    END;
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
  END LOOP;
END;
/
SPOOL OFF
;
