CREATE OR REPLACE PACKAGE DBXNET.CREDIT_RECEIVABLES
AS
        PROCEDURE POPULATE_CR_BACK_UP;
        PROCEDURE POPULATE_CR;
END CREDIT_RECEIVABLES;

---------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY dbxnet.credit_receivables AS
        /*
        PURPOSE:      PACKAGE HANDLES CR LOGIC
        REMARKS:
        WHO     DATE        DESCRIPTION
        ------  ----------  --------------------------------
        SUKRIT   12.07.2023  CREATED
        SUKRIT   04.24.2024  Atul's suggestions incorporated
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
        END IF;

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
            dbxnet.creditreceivables_t t
        WHERE
            to_char(t.insert_date, 'YYYY-MM-DD') = to_char(sysdate, 'YYYY-MM-DD');

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

            EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES_T';
            EXECUTE IMMEDIATE Q'['DELETE FROM DBXNET.CREDITRECEIVABLES_DUMP WHERE TO_CHAR(SYSDATE, 'DDMMYYYY') - TO_CHAR(CURRENT_TIMESTAMP, 'DDMMYYYY') > 30']'
            ;
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
        ELSE
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('NO DATA IN TEMP TABLE')]';
            COMMIT;
        END IF;

    EXCEPTION
                        -- HANDLES ALL ERRORS
        WHEN OTHERS THEN
            dbms_output.put_line('EXCEPTION IN POPULATE_CR');
            EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR')]';
            COMMIT;
    END populate_cr;

END credit_receivables;
--------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.CREDITRECEIVABLES_T ADD CREDIT_SEQ NUMBER(9,0);

CREATE SEQUENCE DBXNET.CRED_D_SEQ_TEMP INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
-------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."CRED_D_TRIGG_TEMP" 
BEFORE INSERT ON DBXNET.CREDITRECEIVABLES_T
FOR EACH ROW
BEGIN
        SELECT
                CRED_D_SEQ_TEMP.NEXTVAL
        INTO
                :NEW.CREDIT_SEQ
        FROM
                DUAL;
END;
/
ALTER TRIGGER "DBXNET"."CRED_D_TRIGG_TEMP" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------IF EXISTS-------------------------------------------------------
DROP TRIGGER "DBXNET"."CRED_D_TRIGG" ;

-------------------------------------------------------------------------------------------------------------------------------------------------
DROP SEQUENCE DBXNET.CRED_D_SEQ;
--------------------------------------------------------------------------------------------------------------------------------------------------
DROP TRIGGER "DBXNET"."CRED_D_TRIGG_BCK" ;
----------------------------------------------------------------------------------------------------------------------------------------------
DROP TRIGGER "DBXNET"."CRED_D_TRIGG_BCK" ENABLE;
---------------------------------------------------------------------------------------------------------------------------------------------