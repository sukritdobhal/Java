SET DEFINE OFF
SET SERVEROUTPUT ON SIZE 200000

DECLARE
    too_many_values EXCEPTION;
    PRAGMA exception_init ( too_many_values, -1427 );
    ln_affected_rows NUMBER := 0;
BEGIN
    EXECUTE IMMEDIATE Q'[ALTER SYSTEM SET ddl_lock_timeout=2000]';
    EXECUTE IMMEDIATE Q'[ALTER SESSION SET CURRENT_SCHEMA = DBXNET]';
    EXECUTE IMMEDIATE Q'[ALTER SEQUENCE DBXNET.AUDIT_LOG_SEQ RESTART START WITH 1]';
-----------------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE Q'[TRUNCATE TABLE DBXNET.AUDIT_LOG]';
    COMMIT;
-----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.igak_d
    SET
        sap_credit_number = substr(foss_auf_nr, 5, 11);

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'IAGK_D UPDATE SAP_CREDIT_NUMER',
        ln_affected_rows
    );

---------------------------------------------BLOB-------------------------------------------------------------------------------------------------

    DECLARE
        igak_blob NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT
                a.atm_blob,
                c.orderid
            FROM
                     dbsiii.atmb_d a
                JOIN dbsiii.atm_d  b ON a.atm_eind_key = b.file_text
                JOIN dbxnet.igak_d c ON TRIM(c.foss_auf_nr) = substr(TRIM(b.sa_fanr_key),
                                                                     - 11,
                                                                     11)
            WHERE
                b.sa_fanr_key LIKE 'VGNR%'
        ) LOOP
            UPDATE dbxnet.igak_d
            SET
                credit_blob = i.atm_blob
            WHERE
                orderid = i.orderid;

            igak_blob := igak_blob + SQL%rowcount;
        END LOOP;

        dbms_output.put_line('Number of rows updated IGAK_blob'
                             || ' '
                             || igak_blob);
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'IGAK_BLOB',
            igak_blob
        );

    END;

    COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('NO OBJECTS_TAB RECORD FOUND FOR OBJECT ');
    WHEN too_many_values THEN
        dbms_output.put_line('MULTIPLE OBJECTS_TAB RECORDS FOUND FOR OBJECT ');
---------------------------------------------------------------------------------------------------------------------------------------------------
END;