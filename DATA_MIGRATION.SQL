CREATE OR REPLACE PACKAGE DBXNET.DATA_MIGRATION
AS
        PROCEDURE POPULATE_IGAK;
        PROCEDURE POPULATE_BLOB;
END DATA_MIGRATION;
CREATE OR REPLACE PACKAGE BODY DBXNET.DATA_MIGRATION
AS
        PROCEDURE POPULATE_IGAK AS type array_t is table of varchar2(100);
        l_customers array_t;
        TYPE numbers_aat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        l_numbers numbers_aat;
                BEGIN
                        SELECT DISTINCT
                                (t2.SAP_CUST_NUMBER) BULK COLLECT
                        INTO
                                l_customers
                        FROM
                                DBXNET.IGAK_D t1
                        JOIN
                                DBXNET.SAPCUST_KTO_MAP t2
                        ON
                                CAST(t2.KTO_NR AS VARCHAR2 (200)) = SUBSTR (t1.FA_KTO_NR, 7, 10);
                        SELECT DISTINCT
                                (KTO_NR) BULK COLLECT
                        INTO
                                l_numbers
                        FROM
                                DBXNET.IGAK_D t1
                        JOIN
                                DBXNET.SAPCUST_KTO_MAP t2
                        ON
                                CAST(t2.KTO_NR AS VARCHAR2 (200)) = SUBSTR (t1.FA_KTO_NR, 7, 10)
                        ORDER BY
                                KTO_NR;
                        FOR indx IN l_customers.FIRST .. l_customers.LAST
                        LOOP DBMS_OUTPUT.put_line (l_customers (indx));
                                UPDATE
                                        DBXNET.IGAK_D D
                                SET
                                        D.SAP_CUST_NUMBER = l_customers(indx)
                                WHERE
                                        SUBSTR (D.FA_KTO_NR, 7, 10) = CAST(l_numbers(indx) AS VARCHAR2 (200));
                                COMMIT;
                        END LOOP;
                END POPULATE_IGAK;
        --------------------------------------------------------------------------------------------------------------------------------------------------------
        PROCEDURE POPULATE_BLOB IS
        CURSOR C_BLOB IS
                SELECT
                        A.ATM_BLOB,
                        TRIM(C.FOSS_AUF_NR)
                FROM
                        DBSIII.ATMB_D A
                JOIN
                        DBSIII.ATM_D B
                ON
                        A.ATM_EIND_KEY = B.FILE_TEXT
                JOIN
                        DBXNET.IGAK_D C
                ON
                        TRIM(C.FOSS_AUF_NR) = SUBSTR(TRIM(B.SA_FANR_KEY), -11, 11)
                WHERE
                        B.SA_FANR_KEY LIKE 'VGNR%';
                v_blob BLOB;
                v_foss varchar2;
                        BEGIN
                                OPEN C_BLOB;
                                LOOP
                                        FETCH   C_BLOB
                                        INTO
                                                v_blob,
                                                v_foss;
                                        EXIT WHEN C_BLOB%NOTFOUND;
                                        DBMS_OUTPUT.PUT_LINE (v_foss);
                                        UPDATE
                                                DBXNET.IGAK_D
                                        SET
                                                CREDIT_BLOB = v_blob
                                        WHERE
                                                TRIM(FOSS_AUF_NR) = v_foss;
                                        COMMIT;
                                END LOOP;
                                CLOSE C_BLOB;
                        END POPULATE_BLOB;
END DATA_MIGRATION;