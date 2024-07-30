SET DEFINE OFF
SET SERVEROUTPUT ON SIZE 200000

DECLARE
    too_many_values EXCEPTION;
    auko_no EXCEPTION;
    iak_diff EXCEPTION;
    PRAGMA exception_init ( too_many_values, -1427 );
    v_iak            NUMBER := 0;
    v_auko           NUMBER := 0;
    v_auko_dbxnet    NUMBER := 0;
    ln_affected_rows NUMBER := 0;
    v_iak_foss       NUMBER := 0;
    v_auko_foss      NUMBER := 0;
    v_diff_foss      NUMBER := 0;
BEGIN
    EXECUTE IMMEDIATE Q'[ALTER SYSTEM SET ddl_lock_timeout=2000]';
    EXECUTE IMMEDIATE Q'[ALTER SESSION SET CURRENT_SCHEMA = DBXNET]';
    EXECUTE IMMEDIATE Q'[ALTER SEQUENCE DBXNET.AUDIT_LOG_SEQ RESTART START WITH 1]';
-----------------------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE Q'[TRUNCATE TABLE DBXNET.AUDIT_LOG]';
    COMMIT;
-----------------------------------------------------------------------------------------------------------------------------------
    SELECT
        COUNT(*)
    INTO v_iak
    FROM
        dbxnet.iak_d;

    SELECT
        COUNT(*)
    INTO v_auko
    FROM
        dbauft.auko_d;
-----------------------------------------------------------------------------------------------------------------------------------
    dbms_output.put_line('***************************************ORDER UPDATES STARTS****************************');
    dbms_output.put_line('Number of rows PRE-UPDATE IAK_D'
                         || ' '
                         || v_iak);
    dbms_output.put_line('Number of rows PRE-UPDATE AUKO_D'
                         || ' '
                         || v_auko);
--------------------------------------------------------------------------------------------------------------------------------------
    dbms_output.put_line('SETTING FA_KTO_NR IN AUKO_D');
--------------------------------------------------CHECKING IF AUKO DBXNET CONSIST-----------------------------------------------------------------------------------------------

    SELECT
        COUNT(*)
    INTO v_auko_dbxnet
    FROM
        dbxnet.auko_d;

    IF ( v_auko_dbxnet = 0 ) THEN
        RAISE auko_no;
    ELSE
        NULL;
    END IF;

--------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.auko_d
    SET
        fa_kto_nr = TRIM(firm_nr)
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(firm_nr) = 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'AUKO_D SET FA_KTO_NR1',
        ln_affected_rows
    );
----------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.auko_d
    SET
        fa_kto_nr = TRIM(firm_nr)
                    || ' '
                    || ' '
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(firm_nr) <> 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'AUKO_D SET FA_KTO_NR2',
        ln_affected_rows
    );
----------------------------------------------------------------------------------------------------------------------------------------
    IF ( v_iak < v_auko ) THEN
        INSERT INTO dbxnet.iak_d (
            fa_kto_nr,
            fw_cd,
            foss_auf_nr,
            sap_order_number,
            li_ter_tag,
            zahl_kond_nr,
            val_dat,
            nebk_sl_tab3_1,
            nebk_sl_tab3_2,
            nebk_sl_tab3_3,
            nebk_pr_tab3_1,
            nebk_pr_tab3_2,
            nebk_pr_tab3_3,
            nebk_kz_tab3_1,
            nebk_kz_tab3_2,
            nebk_kz_tab3_3,
            lort,
            kon_sl3,
            status_kz,
            last_mod_date,
            last_mod_time,
            is_migrated,
            fa_nr,
            au_nr_ku,
            prog_ident
        )
            SELECT
                ( firm_nr
                  || ' '
                  || ' '
                  || kto_nr ),
                fw_cd,
                auf_nr,
                auf_nr,
                au_dat,
                zahl_kond_nr,
                val_dat,
                nebk_sl_tab3_1,
                nebk_sl_tab3_2,
                nebk_sl_tab3_3,
                nebk_pr_tab3_1,
                nebk_pr_tab3_2,
                nebk_pr_tab3_3,
                nebk_kz_tab3_1,
                nebk_kz_tab3_2,
                nebk_kz_tab3_3,
                lort,
                kon_sl10_3,
                status_kz,
                auf_dat,
                (
                    SELECT
                        TO_NUMBER(to_char(sysdate, 'YYYYMMDD'))
                    FROM
                        dual
                ),
                (
                    SELECT
                        1
                    FROM
                        dual
                ),
                firm_nr,
                au_nr,
                'FOSS'
            FROM
                dbauft.auko_d t2
            WHERE
                t2.firm_nr LIKE 'GUTB'
                AND t2.auf_nr IN (
                    SELECT
                        auf_nr
                    FROM
                        dbauft.auko_d
                    MINUS
                    SELECT
                        foss_auf_nr
                    FROM
                        dbxnet.iak_d
                );

        ln_affected_rows := SQL%rowcount;
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'INSERT',
            'DBXNET.IAK_D INSERT1',
            ln_affected_rows
        );

--------------------------------------------------------------------------------------------------------------
--COMMIT;
--------------------------------------------------------------------------------------------------------------------------
        INSERT INTO dbxnet.iak_d (
            fa_kto_nr,
            fw_cd,
            foss_auf_nr,
            sap_order_number,
            li_ter_tag,
            zahl_kond_nr,
            val_dat,
            nebk_sl_tab3_1,
            nebk_sl_tab3_2,
            nebk_sl_tab3_3,
            nebk_pr_tab3_1,
            nebk_pr_tab3_2,
            nebk_pr_tab3_3,
            nebk_kz_tab3_1,
            nebk_kz_tab3_2,
            nebk_kz_tab3_3,
            lort,
            kon_sl3,
            status_kz,
            last_mod_date,
            last_mod_time,
            is_migrated,
            fa_nr,
            au_nr_ku,
            prog_ident
        )
            SELECT
                ( firm_nr
                  || ' '
                  || ' '
                  || ' '
                  || ' '
                  || kto_nr ),
                fw_cd,
                auf_nr,
                auf_nr,
                au_dat,
                zahl_kond_nr,
                val_dat,
                nebk_sl_tab3_1,
                nebk_sl_tab3_2,
                nebk_sl_tab3_3,
                nebk_pr_tab3_1,
                nebk_pr_tab3_2,
                nebk_pr_tab3_3,
                nebk_kz_tab3_1,
                nebk_kz_tab3_2,
                nebk_kz_tab3_3,
                lort,
                kon_sl10_3,
                status_kz,
                auf_dat,
                (
                    SELECT
                        TO_NUMBER(to_char(sysdate, 'YYYYMMDD'))
                    FROM
                        dual
                ),
                (
                    SELECT
                        1
                    FROM
                        dual
                ),
                firm_nr,
                au_nr,
                'FOSS'
            FROM
                dbauft.auko_d t2
            WHERE
                t2.firm_nr NOT LIKE 'GUTB'
                AND t2.auf_nr IN (
                    SELECT
                        auf_nr
                    FROM
                        dbauft.auko_d
                    MINUS
                    SELECT
                        foss_auf_nr
                    FROM
                        dbxnet.iak_d
                );

        ln_affected_rows := SQL%rowcount;
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'INSERT',
            'DBXNET.IAK_D INSERT2',
            ln_affected_rows
        );

    ELSE
        NULL;
    END IF;

----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------checking all foss_auf_nr exist in IAK--------------------------------------------------------------------------------
    SELECT
        COUNT(DISTINCT(foss_auf_nr))
    INTO v_iak_foss
    FROM
        dbxnet.iak_d;

    SELECT
        COUNT(DISTINCT(auf_nr))
    INTO v_auko_foss
    FROM
        dbxnet.auko_d;

    v_diff_foss := v_iak_foss - v_auko_foss;
    IF ( v_diff_foss <> 0 ) THEN
        RAISE iak_diff;
    ELSE
        COMMIT;
    END IF;

-------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.iak_d
    SET
        is_migrated = 1;
-----------------------------------------------------------------------------------------------------------------
    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'UPDATE',
        'DBXNET.IAK_D I',
        ln_affected_rows
    );
-------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.iak_d
    SET
        sap_order_number = foss_auf_nr
    WHERE
            is_migrated = 1
        AND sap_order_number IS NULL;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.IAK_D SET SAP_ORDER_NUMBER = FOSS_AUF_NR',
        ln_affected_rows
    );
-------------------------------------------------------------------------------------------------------------------------------

    UPDATE dbxnet.umpo_d
    SET
        is_migrated = 1;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMPO_D SET IS_MIGRATED = 1',
        ln_affected_rows
    );
---------------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(fa_nr) LIKE 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMPO_D SET FA_KTO_NR 1',
        ln_affected_rows
    );
-----------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        fa_kto_nr = TRIM(fa_nr)
                    || ' '
                    || ' '
                    || ' '
                    || ' '
                    || kto_nr
    WHERE
        TRIM(fa_nr) NOT LIKE 'GUTB';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMPO_D SET FA_KTO_NR 2',
        ln_affected_rows
    );

--------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        menge = menge * 1000;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET MENGE = MENGE * 1000',
        ln_affected_rows
    );

----------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        ges_wert_fw = ges_wert_fw * 100;

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET GES_WERT_FW = GES_WERT_FW * 100',
        ln_affected_rows
    );
------------------------------------------------------------------------------------------------------------------------------------------------

    UPDATE dbxnet.umsd_d
    SET
        aufart_kz = 'SP'
    WHERE
        aufart_kz = 'ET';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET AUFART_KZ',
        ln_affected_rows
    );
------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        aufart_kz = 'FG'
    WHERE
        aufart_kz = 'FW';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET AUFART_KZ',
        ln_affected_rows
    );
--------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        aufart_kz = 'FG'
    WHERE
        aufart_kz = 'RM';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET AUFART_KZ',
        ln_affected_rows
    );
-----------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.umsd_d
    SET
        aufart_kz = 'WC'
    WHERE
        aufart_kz = 'KD';

    ln_affected_rows := SQL%rowcount;
    INSERT INTO dbxnet.audit_log (
        operation,
        ops_details,
        affected_rows
    ) VALUES (
        'INSERT',
        'DBXNET.UMSD_D SET AUFART_KZ',
        ln_affected_rows
    );
----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
    DECLARE
        
        iak_c  NUMBER := 0;
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
            
            UPDATE dbxnet.iak_d
            SET
                sap_cust_number = i.sap_cust_number,
                sales_org = i.sap_sales_org
            WHERE
                    fa_kto_nr = i.fa_kto_nr;

            iak_c := iak_c + SQL%rowcount;
            
        END LOOP;


        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'IAK_D SAPCUST & SALES_ORG',
            iak_c
        );

    END;

---------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
    DECLARE
        auko_sap NUMBER := 0;
    BEGIN
        FOR i IN (
            SELECT
                fa_kto_nr,
                sap_cust_number
            FROM
                dbxnet.iak_d
            WHERE
                sap_cust_number IS NOT NULL
        ) LOOP
            UPDATE dbxnet.auko_d
            SET
                sap_cust_number = i.sap_cust_number
            WHERE
                    fa_kto_nr = i.fa_kto_nr
                AND sap_cust_number IS NULL
                AND is_migrated = 1;

            auko_sap := auko_sap + SQL%rowcount;
        END LOOP;

        dbms_output.put_line('Number of rows updated auko_sap ' || auko_sap);
        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'UPDATE',
            'Number of rows updated auko_sap',
            auko_sap
        );

    END;
---------------------------------------------------------------------------------------------------------------------------------------------
    UPDATE dbxnet.auko_d
    SET
        sap_order_number = NULL
    WHERE
        sap_cust_number IS NULL; 

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
    COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('NO OBJECTS_TAB RECORD FOUND FOR OBJECT ');
    WHEN too_many_values THEN
        dbms_output.put_line('MULTIPLE OBJECTS_TAB RECORDS FOUND FOR OBJECT ');
    WHEN auko_no THEN
        dbms_output.put_line('NO ROWS IN DBXNET.AUKO_D ');
    WHEN iak_diff THEN
        dbms_output.put_line('DIFF IN FOSS ORDERS BETWEEN IAK AND AUKO AFTER INSERT INTO IAK ');
---------------------------------------------------------------------------------------------------------------------------------------------------
END;