CREATE OR REPLACE PACKAGE dbxnet.credit_receivables AS
    PROCEDURE populate_cr_back_up;

    PROCEDURE populate_cr;

END credit_receivables;

CREATE OR REPLACE PACKAGE BODY dbxnet.credit_receivables AS
        /*
        PURPOSE:      PACKAGE HANDLES CR LOGIC
        REMARKS:
        WHO     DATE        DESCRIPTION
        ------  ----------  --------------------------------
        SUKRIT   12.07.2023  CREATED
        SUKRIT   04.24.2024  Atul's suggestions incorporated
        SUKRIT   04.30.2024  DUMP DELETION ISSUE FIXED
        */
    PROCEDURE populate_cr_back_up AS
        cr_count NUMBER(9, 0);
        b_count  NUMBER(9, 0);
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = DBXNET';
        SELECT
            COUNT(*)
        INTO cr_count
        FROM
            dbxnet.creditreceivables;

        IF cr_count > 0 THEN
            dbms_output.put_line('DATA PRESENT IN MAIN TABLE');
            EXECUTE IMMEDIATE 'DROP TABLE DBXNET.CREDITRECEIVABLES_B';
            EXECUTE IMMEDIATE 'CREATE TABLE DBXNET.CREDITRECEIVABLES_B AS SELECT * FROM DBXNET.CREDITRECEIVABLES';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES';
            COMMIT;
        ELSE
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('NO DATA IN MAIN TABLE')]';
            COMMIT;
		 END IF;
            EXECUTE IMMEDIATE Q'[CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "DBXNET"."CREDIT_RECEIVABLES_V" ("SAP_CUST_NUMBER", "DOC_NUMBER", "DOC_DATE", "AMOUNT", "CURRENCY", "TRX_TYPE", "DOC_TYPE", "ASSIGNEMNET_NUM", "NET_DUE_DATE", "CREDIT_SEQ") AS 
  SELECT DISTINCT
        NVL (CR.SAP_CUST_NUMBER, B.SAP_CUST_NUMBER),
        NVL (CR.DOC_NUMBER, B.DOC_NUMBER)          ,
        NVL (CR.DOC_DATE, B.DOC_DATE)              ,
        NVL (CR.AMOUNT, B.AMOUNT)                  ,
        NVL (CR.CURRENCY, B.CURRENCY)              ,
        NVL (CR.TRX_TYPE, B.TRX_TYPE)              ,
        NVL (CR.DOC_TYPE, B.DOC_TYPE)              ,
        NVL (CR.ASSIGNMENT_NUM, B.ASSIGNMENT_NUM)  ,
        NVL (CR.NET_DUE_DATE, B.NET_DUE_DATE),
        NVL(CR.CREDIT_SEQ, B.CREDIT_SEQ)
FROM
        DBXNET.CREDITRECEIVABLES_B B
FULL JOIN
        DBXNET.CREDITRECEIVABLES CR
ON
        CR.SAP_CUST_NUMBER = B.SAP_CUST_NUMBER]';
       

    EXCEPTION
                        -- HANDLES ALL ERRORS
        WHEN OTHERS THEN
            dbms_output.put_line('EXCEPTION IN POPULATE_CR_BACK_UP');
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR_BACK_UP')]';
            COMMIT;
    END populate_cr_back_up;
        -----------------------------------------------------------
    PROCEDURE populate_cr AS
        t_count  NUMBER(9, 0);
        cr_count NUMBER(9, 0);
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = DBXNET';
        SELECT
            COUNT(*)
        INTO t_count
        FROM
            dbxnet.creditreceivables_t t;
        --WHERE
          --  to_char(t.insert_date, 'YYYY-MM-DD') = to_char(sysdate, 'YYYY-MM-DD');

        INSERT INTO dbxnet.audit_log (
            operation,
            ops_details,
            affected_rows
        ) VALUES (
            'CHECK',
            'COUNT OF TEMP TABLE',
            t_count
        );

        IF ( t_count > 0 ) THEN
            EXECUTE IMMEDIATE 'DROP TABLE DBXNET.CREDITRECEIVABLES';
            EXECUTE IMMEDIATE 'CREATE TABLE DBXNET.CREDITRECEIVABLES AS SELECT * FROM DBXNET.CREDITRECEIVABLES_T';
            INSERT INTO dbxnet.creditreceivables_dump (
                sap_cust_number,
                doc_number,
                doc_date,
                amount,
                currency,
                trx_type,
                doc_type,
                assignment_num,
                net_due_date,
                insert_date
            )
                SELECT
                    sap_cust_number,
                    doc_number,
                    doc_date,
                    amount,
                    currency,
                    trx_type,
                    doc_type,
                    assignment_num,
                    net_due_date,
                    insert_date
                FROM
                    dbxnet.creditreceivables_t t;

            INSERT INTO dbxnet.audit_log (
                operation,
                ops_details,
                affected_rows
            ) VALUES (
                'INSERT',
                'INSERT IN DUMP HAPPENED',
                0
            );

            EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES_T';
            COMMIT;
            INSERT INTO dbxnet.audit_log (
                operation,
                ops_details,
                affected_rows
            ) VALUES (
                'TRUNCATE',
                'DBXNET.CREDITRECEIVABLES_T',
                0
            );

            COMMIT;
            EXECUTE IMMEDIATE Q'[DELETE FROM DBXNET.CREDITRECEIVABLES_DUMP WHERE TO_CHAR(SYSDATE, 'DDMMYYYY') - TO_CHAR(INSERT_DATE, 'DDMMYYYY') > 30]'
            ;
            COMMIT;
            INSERT INTO dbxnet.audit_log (
                operation,
                ops_details,
                affected_rows
            ) VALUES (
                'DELETE',
                'DUMP DELETE 30 DAYS OLD',
                0
            );

            COMMIT;
            INSERT INTO dbxnet.audit_log (
                operation,
                ops_details,
                affected_rows
            ) VALUES (
                'COMPILE',
                ' BEFORE VIEW COMPILED',
                0
            );

            COMMIT;
            EXECUTE IMMEDIATE Q'[CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "DBXNET"."CREDIT_RECEIVABLES_V" ("SAP_CUST_NUMBER", "DOC_NUMBER", "DOC_DATE", "AMOUNT", "CURRENCY", "TRX_TYPE", "DOC_TYPE", "ASSIGNEMNET_NUM", "NET_DUE_DATE", "CREDIT_SEQ") AS 
  SELECT DISTINCT
        NVL (CR.SAP_CUST_NUMBER, B.SAP_CUST_NUMBER),
        NVL (CR.DOC_NUMBER, B.DOC_NUMBER)          ,
        NVL (CR.DOC_DATE, B.DOC_DATE)              ,
        NVL (CR.AMOUNT, B.AMOUNT)                  ,
        NVL (CR.CURRENCY, B.CURRENCY)              ,
        NVL (CR.TRX_TYPE, B.TRX_TYPE)              ,
        NVL (CR.DOC_TYPE, B.DOC_TYPE)              ,
        NVL (CR.ASSIGNMENT_NUM, B.ASSIGNMENT_NUM)  ,
        NVL (CR.NET_DUE_DATE, B.NET_DUE_DATE),
        NVL(CR.CREDIT_SEQ, B.CREDIT_SEQ)
FROM
        DBXNET.CREDITRECEIVABLES_B B
FULL JOIN
        DBXNET.CREDITRECEIVABLES CR
ON
        CR.SAP_CUST_NUMBER = B.SAP_CUST_NUMBER]';
            COMMIT;
            INSERT INTO dbxnet.audit_log (
                operation,
                ops_details,
                affected_rows
            ) VALUES (
                'COMPILE',
                'VIEW COMPILED',
                0
            );

            COMMIT;
        ELSE
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('NO DATA IN TEMP TABLE')]';
            COMMIT;
        END IF;

    EXCEPTION
                        -- HANDLES ALL ERRORS
        WHEN OTHERS THEN
            dbms_output.put_line('EXCEPTION IN POPULATE_CR');
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('EXCEPTION IN POPULATE_CR')]';
            COMMIT;
    END populate_cr;

END credit_receivables;