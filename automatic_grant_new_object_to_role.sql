--1. If the objects had been existed run this command:
BEGIN
    FOR r IN (
        SELECT object_name, object_type
        FROM dba_objects
        WHERE owner = 'MAXIMO'
          AND object_type IN ('TABLE', 'VIEW', 'MATERIALIZED VIEW')
          AND object_name NOT LIKE 'BIN$%'
    )
    LOOP
        BEGIN
            -- READ ONLY
            EXECUTE IMMEDIATE
                'GRANT SELECT ON MAXIMO."' ||
                REPLACE(r.object_name, '"', '""') ||
                '" TO MAXIMO_READ_ONLY';

            -- READ WRITE
            IF r.object_type = 'TABLE' THEN
                EXECUTE IMMEDIATE
                    'GRANT SELECT, INSERT, UPDATE, DELETE ON MAXIMO."' ||
                    REPLACE(r.object_name, '"', '""') ||
                    '" TO MAXIMO_READ_WRITE';
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(
                    'Failed: ' ||
                    r.object_type || ' ' ||
                    r.object_name || ' - ' ||
                    SQLERRM
                );
        END;
    END LOOP;
END;
/

--2. Then create this trigger
CREATE OR REPLACE TRIGGER MAXIMO_AUTO_GRANT
AFTER CREATE ON DATABASE
DECLARE
    l_owner VARCHAR2(128);
    l_name  VARCHAR2(128);
    l_type  VARCHAR2(128);
BEGIN
    l_owner := ora_dict_obj_owner;
    l_name  := ora_dict_obj_name;
    l_type  := ora_dict_obj_type;

    IF l_owner = 'MAXIMO' THEN

        -- READ ONLY
        IF l_type IN ('TABLE', 'VIEW', 'MATERIALIZED VIEW') THEN

            EXECUTE IMMEDIATE
                'GRANT SELECT ON MAXIMO."' ||
                REPLACE(l_name, '"', '""') ||
                '" TO MAXIMO_READ_ONLY';

        END IF;

        -- READ WRITE
        IF l_type = 'TABLE' THEN

            EXECUTE IMMEDIATE
                'GRANT SELECT, INSERT, UPDATE, DELETE ON MAXIMO."' ||
                REPLACE(l_name, '"', '""') ||
                '" TO MAXIMO_READ_WRITE';

        END IF;

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'MAXIMO_AUTO_GRANT failed for ' ||
            l_owner || '.' || l_name ||
            ': ' || SQLERRM
        );
END;
/

--3. Enable the trigger
ALTER TRIGGER MAXIMO_AUTO_GRANT ENABLE;

--4. Grant the roles to the user
