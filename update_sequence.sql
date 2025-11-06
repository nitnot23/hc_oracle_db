SET SERVEROUTPUT ON;

DECLARE
    v_sql       VARCHAR2(1000);
    v_max_id    NUMBER;
    v_seq_val   NUMBER;
    v_diff      NUMBER;
BEGIN
    FOR seq_rec IN (
        SELECT sequence_name 
        FROM user_sequences
    ) LOOP
        BEGIN
            -- Try to find a matching table by name
            DECLARE
                v_table VARCHAR2(100);
                v_column VARCHAR2(100);
            BEGIN
                SELECT table_name, column_name
                INTO v_table, v_column
                FROM (
                    SELECT t.table_name, c.column_name
                    FROM user_tables t
                    JOIN user_tab_columns c
                      ON t.table_name = c.table_name
                    WHERE seq_rec.sequence_name LIKE t.table_name || '%'
                      AND c.column_name LIKE '%ID%'
                      AND c.data_type IN ('NUMBER', 'INTEGER')
                    ORDER BY c.column_id
                )
                WHERE ROWNUM = 1;

                -- Get max value
                v_sql := 'SELECT NVL(MAX(' || v_column || '),0) FROM ' || v_table;
                EXECUTE IMMEDIATE v_sql INTO v_max_id;

                -- Get current sequence value
                EXECUTE IMMEDIATE 'SELECT ' || seq_rec.sequence_name || '.NEXTVAL FROM dual' INTO v_seq_val;

                v_diff := v_max_id - v_seq_val + 1;

                IF v_diff > 0 THEN
                    EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_rec.sequence_name || ' INCREMENT BY ' || v_diff;
                    EXECUTE IMMEDIATE 'SELECT ' || seq_rec.sequence_name || '.NEXTVAL FROM dual' INTO v_seq_val;
                    EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_rec.sequence_name || ' INCREMENT BY 1';
                    DBMS_OUTPUT.PUT_LINE('✅ ' || seq_rec.sequence_name || ' updated to ' || v_seq_val ||
                                         ' (Table=' || v_table || ', Column=' || v_column || ')');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('👌 ' || seq_rec.sequence_name || ' already up-to-date.');
                END IF;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('⚠️  No matching table found for sequence ' || seq_rec.sequence_name);
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('❌ Error for sequence ' || seq_rec.sequence_name || ': ' || SQLERRM);
            END;
        END;
    END LOOP;
END;
/
