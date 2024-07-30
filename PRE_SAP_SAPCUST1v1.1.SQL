SET DEFINE OFF
SET SERVEROUTPUT ON SIZE 200000

DECLARE
    too_many_values EXCEPTION;
    fa_kto EXCEPTION;
    PRAGMA exception_init ( too_many_values, -1427 );
    v_sap            NUMBER := 0;
    v_salesorg       NUMBER := 0;
    ln_affected_rows NUMBER := 0;
    v_fakto_1        NUMBER := 0;
    v_fakto_2        NUMBER := 0;
BEGIN
    EXECUTE IMMEDIATE Q'[ALTER SYSTEM SET ddl_lock_timeout=2000]';
    EXECUTE IMMEDIATE Q'[ALTER SESSION SET CURRENT_SCHEMA = DBXNET]';
    EXECUTE IMMEDIATE Q'[ALTER SEQUENCE DBXNET.AUDIT_LOG_SEQ RESTART START WITH 1]';
-------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE Q'[TRUNCATE TABLE DBXNET.AUDIT_LOG]';
    COMMIT;

--------------------------------------------------------------------------------------------------------------------------------
    dbms_output.put_line('***************************************PRE SAP UPDATES STARTS****************************');
-------------------------------------------------------------------------------------------------------------------------	
    SELECT
        COUNT(*)
    INTO v_sap
    FROM
        dbxnet.newsapcust_kto_map
    WHERE
        sap_cust_number IS NULL;

    IF ( v_sap > 0 ) THEN
        dbms_output.put_line('SOME RECORDS IN NEWSAPCUST HAVE NULL SAP CUST NUMBERS');
    ELSE
        NULL;
    END IF;
---------------------------------------------------------------------------------------------------------------------------
    SELECT
        COUNT(*)
    INTO v_salesorg
    FROM
        dbxnet.newsapcust_kto_map
    WHERE
        length(TRIM(sap_sales_org)) > 4;

    IF ( v_salesorg > 0 ) THEN
        dbms_output.put_line('SOME RECORDS IN NEWSAPCUST HAVE INVALID SAP_SALES_ORG');
    ELSE
        NULL;
    END IF;
-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.newsapcust_kto_map
    SET
        foss_sales_org = TRIM(foss_sales_org),
        sap_cust_number = TRIM(sap_cust_number),
        sap_sales_org = TRIM(sap_sales_org);

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'NEWSAPCUST TRIM FOSS SALES ORG',
        ln_affected_rows
    );
---------------------------------------------------------------------------------------------------------------------------------------------------

 -------------------------------SETTING FA_KTO_NR---------------------------------------------------------------------------------------
    UPDATE dbxnet.newsapcust_kto_map
    SET
        fa_kto_nr = TRIM(foss_sales_org)
                    || ' '
                    || ' '
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(foss_sales_org) <> 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'NEWSAPCUST SETTING FA_KTO_NR',
        ln_affected_rows
    );
 --------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.newsapcust_kto_map
    SET
        fa_kto_nr = TRIM(foss_sales_org)
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(foss_sales_org) = 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'NEWSAPCUST TRIM1 FA_KTO_NR',
        ln_affected_rows
    );

 --------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.newsapcust_kto_map
    SET
        fa_kto_nr = TRIM(fa_kto_nr); ----DO AFTER SET-UP---------------------
    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'NEWSAPCUST TRIM2 FA_KTO_NR',
        ln_affected_rows
    );
--------------------------------------------------------------------------------------------------------------------------------------------------
    SELECT
        MAX(length(fa_kto_nr))
    INTO v_fakto_1
    FROM
        dbxnet.newsapcust_kto_map;

    SELECT
        MIN(length(fa_kto_nr))
    INTO v_fakto_2
    FROM
        dbxnet.newsapcust_kto_map;

    IF ( v_fakto_1 = 14 ) THEN
        IF ( v_fakto_2 = 14 ) THEN
            NULL;
        ELSE
            RAISE fa_kto;
        END IF;
    ELSE
        RAISE fa_kto;
    END IF;

--------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.sapvert_map
    SET
        sales_org = TRIM(sales_org);

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'NEWSAPCUST TRIM2 FA_KTO_NR',
        ln_affected_rows
    );
--------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.sapvert_map
    SET
        sap_vert_nr = TRIM(sap_vert_nr),
        vert_nr = TRIM(vert_nr);

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'SAPVERTMAP TRIM',
        ln_affected_rows
    );

 ----------------------------------------------------------------------------------------------------------------------------------------------- 
 -----FA_KTO_NR---------------------------------------------------------------------------------------
    UPDATE dbxnet.dfzg_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || ' '
                    || ' '
                    || TRIM(kunde)
    WHERE
            TRIM(fa_nr) <> 'GUTB'
        AND kunde <> 0;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'BXNET.DFZG_D SET FA_KTO_NR1',
        ln_affected_rows
    );
 --------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.dfzg_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || TRIM(kunde)
    WHERE
            TRIM(fa_nr) = 'GUTB'
        AND kunde <> 0;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'BXNET.DFZG_D SET FA_KTO_NR2',
        ln_affected_rows
    );

-----FA_KTO_NR---------------------------------------------------------------------------------------
    UPDATE dbxnet.dfzg_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || ' '
                    || ' '
                    || TRIM(kunde)
    WHERE
            TRIM(fa_nr) <> 'GUTB'
        AND kunde <> 0;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'BXNET.DFZG_D SET FA_KTO_NR1',
        ln_affected_rows
    );
 --------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.dfzg_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || TRIM(kunde)
    WHERE
            TRIM(fa_nr) = 'GUTB'
        AND kunde <> 0;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'BXNET.DFZG_D SET FA_KTO_NR2',
        ln_affected_rows
    );

-----------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------------

    DECLARE
        ln_affected_rowz NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT
                kdgr,
                fa_kto_nr
            FROM
                dbauft.kd01_d
            WHERE
                fa_kto_nr IN (
                    SELECT
                        fa_kto_nr
                    FROM
                        dbxnet.newsapcust_kto_map
                )
        ) LOOP
            UPDATE dbxnet.newsapcust_kto_map
            SET
                kdgr = i.kdgr
            WHERE
                fa_kto_nr = i.fa_kto_nr;

            ln_affected_rowz := ln_affected_rowz + SQL%rowcount;
        END LOOP;

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'DBXNET.NEWSAPCUST_KTO_MAP SET KDGR = I.KDGR',
            ln_affected_rows
        );

    END;
---------------------------------------------------------------------------------------------------------------------------------------------------
    DECLARE
        uli_c  NUMBER := 0;
        igak_c NUMBER := 0;
        iak_c  NUMBER := 0;
        umpo_c NUMBER := 0;
        dfsg_c NUMBER := 0;
        roif_c NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT
                sap_cust_number,
                fa_kto_nr,
                sap_sales_org,
                kto_nr
            FROM
                dbxnet.newsapcust_kto_map
        ) LOOP
            UPDATE dbxnet.uli_m
            SET
                sap_cust_number = i.sap_cust_number,
                sales_org = i.sap_sales_org
            WHERE
                kto_nr = i.kto_nr;

            uli_c := uli_c + SQL%rowcount;
            UPDATE dbxnet.igak_d
            SET
                sap_cust_number = i.sap_cust_number,
                sales_org = i.sap_sales_org
            WHERE
                fa_kto_nr = i.fa_kto_nr;

            igak_c := igak_c + SQL%rowcount;
            UPDATE dbxnet.iak_d
            SET
                sap_cust_number = i.sap_cust_number,
                sales_org = i.sap_sales_org
            WHERE
                    fa_kto_nr = i.fa_kto_nr
                AND is_migrated = 1;

            iak_c := iak_c + SQL%rowcount;
            UPDATE dbxnet.umpo_d
            SET
                sap_cust_number = i.sap_cust_number,
                sales_org = i.sap_sales_org
            WHERE
                    fa_kto_nr = i.fa_kto_nr
                AND sap_cust_number IS NULL
                AND is_migrated = 1;

            umpo_c := umpo_c + SQL%rowcount;
            UPDATE dbxnet.dfzg_d d
            SET
                d.sap_cust_number = i.sap_cust_number
            WHERE
                    d.fa_kto_nr = i.fa_kto_nr
                AND d.kunde <> 0;

            dfsg_c := dfsg_c + SQL%rowcount;
            UPDATE dbxnet.dfzg_d d
            SET
                d.sap_cust_number = '0'
            WHERE
                d.kunde = 0;

            dfsg_c := dfsg_c + SQL%rowcount;
            UPDATE dbxnet.roif_d
            SET
       -- SALES_ORG = I.SAP_SALES_ORG,
                sap_cust_number = i.sap_cust_number
            WHERE
                fa_kto_nr = i.fa_kto_nr;

            roif_c := roif_c + SQL%rowcount;
        END LOOP;

        dbms_output.put_line('Number of rows updated ULI_M'
                             || ' '
                             || uli_c);
        dbms_output.put_line('Number of rows updated IGAK_D'
                             || ' '
                             || igak_c);
        dbms_output.put_line('Number of rows updated IAK_D'
                             || ' '
                             || iak_c);
        dbms_output.put_line('Number of rows updated UMPO_D'
                             || ' '
                             || umpo_c);
        dbms_output.put_line('Number of rows updated dfsg_D'
                             || ' '
                             || dfsg_c);
        dbms_output.put_line('Number of rows updated roif_D'
                             || ' '
                             || roif_c);
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'ULI_M SAPCUST & SALES_ORG',
            uli_c
        );

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'IGAK_D SAPCUST & SALES_ORG',
            igak_c
        );

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'IAK_D SAPCUST & SALES_ORG',
            iak_c
        );

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'UMPO_D SAPCUST & SALES_ORG',
            umpo_c
        );

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'dfsg_D SAPCUST & SALES_ORG',
            dfsg_c
        );

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'roif_D SAPCUST & SALES_ORG',
            roif_c
        );

    END;

---------------------------------------------------------------------------------------------------------------------------------------------

    DECLARE
        uli_vert NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT
                *
            FROM
                dbxnet.sapvert_map
        ) LOOP
            UPDATE dbxnet.uli_m
            SET
                sap_vert_nr = i.sap_vert_nr,
                sales_org = i.sales_org
            WHERE
                vert_nr = i.vert_nr;

            uli_vert := uli_vert + SQL%rowcount;
        END LOOP;

        UPDATE dbxnet.uli_m
        SET
            sap_cust_number = '0'
        WHERE
            kto_nr = 0;

        dbms_output.put_line('Number of rows updated uli_vert ' || uli_vert);
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'Number of rows updated uli_vert',
            uli_vert
        );

    END;

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
    COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('NO OBJECTS_TAB RECORD FOUND FOR OBJECT ');
    WHEN too_many_values THEN
        dbms_output.put_line('MULTIPLE OBJECTS_TAB RECORDS FOUND FOR OBJECT ');
    WHEN fa_kto THEN
        dbms_output.put_line('FA_KTO_NR NOT SET PROPERLY ');
---------------------------------------------------------------------------------------------------------------------------------------------------
END;