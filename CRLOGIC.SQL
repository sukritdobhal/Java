-----------------------------------------------------------------------------------------------------------------------------------------

-- DBXNET.CREDITRECEIVABLES definition

CREATE TABLE "DBXNET"."CREDITRECEIVABLES" 
   (	"SAP_CUST_NUMBER" VARCHAR2(200), 
	"DOC_NUMBER" VARCHAR2(100), 
	"DOC_DATE" VARCHAR2(9), 
	"AMOUNT" VARCHAR2(100), 
	"CURRENCY" VARCHAR2(20), 
	"TRX_TYPE" VARCHAR2(10), 
	"DOC_TYPE" VARCHAR2(10), 
	"ASSIGNMENT_NUM" VARCHAR2(100), 
	"NET_DUE_DATE" VARCHAR2(9), 
	"INSERT_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"CREDIT_SEQ" NUMBER(9,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."CRED_D_TRIGG" 
BEFORE INSERT ON DBXNET.CREDITRECEIVABLES
FOR EACH ROW
BEGIN
        SELECT
                CRED_D_SEQ.NEXTVAL
        INTO
                :NEW.CREDIT_SEQ
        FROM
                DUAL;
END;
/
ALTER TRIGGER "DBXNET"."CRED_D_TRIGG" ENABLE;

--GRANT SELECT ON "DBXNET"."CREDITRECEIVABLES" TO "ROUSER";
-------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE DBXNET.CRED_D_SEQ INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
------------------------------------------------------------------------------------------------------------------------------------------------
-- DBXNET.CREDITRECEIVABLES_B definition

CREATE TABLE "DBXNET"."CREDITRECEIVABLES_B" 
   (	"SAP_CUST_NUMBER" VARCHAR2(200), 
	"DOC_NUMBER" VARCHAR2(100), 
	"DOC_DATE" VARCHAR2(9), 
	"AMOUNT" VARCHAR2(100), 
	"CURRENCY" VARCHAR2(20), 
	"TRX_TYPE" VARCHAR2(10), 
	"DOC_TYPE" VARCHAR2(10), 
	"ASSIGNMENT_NUM" VARCHAR2(100), 
	"NET_DUE_DATE" VARCHAR2(9), 
	"INSERT_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" ;

--GRANT SELECT ON "DBXNET"."CREDITRECEIVABLES_B" TO "ROUSER";

-----------------------------------------------------------------------------------------------------------------------------------------
--GRANT SELECT ON "DBXNET"."CREDITRECEIVABLES_B" TO "ROUSER";
ALTER TABLE DBXNET.CREDITRECEIVABLES_B ADD CREDIT_SEQ NUMBER(9,0);
-------------------------------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE DBXNET.CRED_D_SEQ_BCK INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
-------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."CRED_D_TRIGG_BCK" 
BEFORE INSERT ON DBXNET.CREDITRECEIVABLES
FOR EACH ROW
BEGIN
        SELECT
                CRED_D_SEQ.NEXTVAL
        INTO
                :NEW.CREDIT_SEQ
        FROM
                DUAL;
END;
/
ALTER TRIGGER "DBXNET"."CRED_D_TRIGG_BCK" ENABLE;

-------------------------------------------------------------------------------------------------------------------------------------
-- DBXNET.CREDITRECEIVABLES_DUMP definition

CREATE TABLE "DBXNET"."CREDITRECEIVABLES_DUMP" 
   (	"SAP_CUST_NUMBER" VARCHAR2(200), 
	"DOC_NUMBER" VARCHAR2(100), 
	"DOC_DATE" VARCHAR2(9), 
	"AMOUNT" VARCHAR2(100), 
	"CURRENCY" VARCHAR2(20), 
	"TRX_TYPE" VARCHAR2(10), 
	"DOC_TYPE" VARCHAR2(10), 
	"ASSIGNMENT_NUM" VARCHAR2(100), 
	"NET_DUE_DATE" VARCHAR2(9), 
	"INSERT_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" ;
 ------------------------------------------------------------------------------------------------------------------------------------
 

-- DBXNET.CREDITRECEIVABLES_T definition

CREATE TABLE "DBXNET"."CREDITRECEIVABLES_T" 
   (	"SAP_CUST_NUMBER" VARCHAR2(200), 
	"DOC_NUMBER" VARCHAR2(100), 
	"DOC_DATE" VARCHAR2(9), 
	"AMOUNT" VARCHAR2(100), 
	"CURRENCY" VARCHAR2(20), 
	"TRX_TYPE" VARCHAR2(10), 
	"DOC_TYPE" VARCHAR2(10), 
	"ASSIGNMENT_NUM" VARCHAR2(100), 
	"NET_DUE_DATE" VARCHAR2(9), 
	"INSERT_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" ;

CREATE UNIQUE INDEX "DBXNET"."CREDIT_CONSTRAINT" ON "DBXNET"."CREDITRECEIVABLES_T" ("SAP_CUST_NUMBER", "DOC_NUMBER", "ASSIGNMENT_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" ;

--GRANT SELECT ON "DBXNET"."CREDITRECEIVABLES_T" TO "ROUSER";

---------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY DBXNET.CREDIT_RECEIVABLES
AS
        /*
        PURPOSE:      PACKAGE HANDLES CR LOGIC
        REMARKS:
        WHO     DATE        DESCRIPTION
        ------  ----------  --------------------------------
        SUKRIT   12.07.2023  CREATED
        */
        PROCEDURE POPULATE_CR_BACK_UP AS CR_COUNT NUMBER(9,0);
        B_COUNT                                   NUMBER(9,0);
                BEGIN
                        EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = DBXNET';
                        SELECT
                                COUNT (*)
                        INTO
                                CR_COUNT
                        FROM
                                DBXNET.CREDITRECEIVABLES;
                        IF
                                CR_COUNT > 0
                        THEN
                                DBMS_OUTPUT.PUT_LINE ('DATA PRESENT IN MAIN TABLE');
                                EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES_B';
                                INSERT INTO
                                        DBXNET.CREDITRECEIVABLES_B
                                                (
                                                        SAP_CUST_NUMBER,
                                                        DOC_NUMBER     ,
                                                        DOC_DATE       ,
                                                        AMOUNT         ,
                                                        CURRENCY       ,
                                                        TRX_TYPE       ,
                                                        DOC_TYPE       ,
                                                        ASSIGNMENT_NUM ,
                                                        NET_DUE_DATE
                                                )
                                SELECT
                                        SAP_CUST_NUMBER,
                                        DOC_NUMBER     ,
                                        DOC_DATE       ,
                                        AMOUNT         ,
                                        CURRENCY       ,
                                        TRX_TYPE       ,
                                        DOC_TYPE       ,
                                        ASSIGNMENT_NUM ,
                                        NET_DUE_DATE
                                FROM
                                        DBXNET.CREDITRECEIVABLES;
                                SELECT
                                        COUNT(*)
                                INTO
                                        B_COUNT
                                FROM
                                        DBXNET.CREDITRECEIVABLES_B;
                                IF
                                        CR_COUNT = B_COUNT
                                THEN
                                        DBMS_OUTPUT.PUT_LINE ('COUNT OF CR TABLE = COUNT OF BACKUP TABLE');
                                        EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES';
                                        COMMIT;
                                ELSE
                                        EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('COUNT OF MAIN TABLE <> BACKUP TABLE')]';
                                        COMMIT;
                                END IF;
                        ELSE
                                EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('NO DATA IN MAIN TABLE')]';
                                COMMIT;
                        END IF;
                EXCEPTION
                        -- HANDLES ALL ERRORS
                        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION IN POPULATE_CR_BACK_UP');
                        EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR_BACK_UP')]';
                        COMMIT;
                END POPULATE_CR_BACK_UP;
        -----------------------------------------------------------
        PROCEDURE POPULATE_CR AS T_COUNT NUMBER(9,0);
        CR_COUNT                         NUMBER(9,0);
                BEGIN
                        EXECUTE IMMEDIATE 'ALTER SESSION SET CURRENT_SCHEMA = DBXNET';
                        SELECT
                                COUNT (*)
                        INTO
                                T_COUNT
                        FROM
                                DBXNET.CREDITRECEIVABLES_T T
                        WHERE
                                TO_CHAR(T.INSERT_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
                        INSERT INTO
                                DBXNET.CREDITRECEIVABLES
                                        (
                                                SAP_CUST_NUMBER,
                                                DOC_NUMBER     ,
                                                DOC_DATE       ,
                                                AMOUNT         ,
                                                CURRENCY       ,
                                                TRX_TYPE       ,
                                                DOC_TYPE       ,
                                                ASSIGNMENT_NUM ,
                                                NET_DUE_DATE
												
                                        )
                        SELECT
                                SAP_CUST_NUMBER,
                                DOC_NUMBER     ,
                                DOC_DATE       ,
                                AMOUNT         ,
                                CURRENCY       ,
                                TRX_TYPE       ,
                                DOC_TYPE       ,
                                ASSIGNMENT_NUM ,
                                NET_DUE_DATE
								
                        FROM
                                DBXNET.CREDITRECEIVABLES_T T
                        WHERE
                                TO_CHAR(T.INSERT_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
                        SELECT
                                COUNT(*)
                        INTO
                                CR_COUNT
                        FROM
                                DBXNET.CREDITRECEIVABLES M
                        WHERE
                                TO_CHAR(M.INSERT_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
                        IF
                                T_COUNT = CR_COUNT
                        THEN
                                DBMS_OUTPUT.PUT_LINE ('COUNT OF TEMP TABLE = COUNT OF CR TABLE');
								         INSERT INTO
                          DBXNET.CREDITRECEIVABLES_DUMP
                                        (
                                                SAP_CUST_NUMBER,
                                                DOC_NUMBER     ,
                                                DOC_DATE       ,
                                                AMOUNT         ,
                                                CURRENCY       ,
                                                TRX_TYPE       ,
                                                DOC_TYPE       ,
                                                ASSIGNMENT_NUM ,
                                                NET_DUE_DATE,
												INSERT_DATE
                                        )
                        SELECT
                                SAP_CUST_NUMBER,
                                DOC_NUMBER     ,
                                DOC_DATE       ,
                                AMOUNT         ,
                                CURRENCY       ,
                                TRX_TYPE       ,
                                DOC_TYPE       ,
                                ASSIGNMENT_NUM ,
                                NET_DUE_DATE,
								INSERT_DATE
                        FROM
                                DBXNET.CREDITRECEIVABLES_T T
                        WHERE
                                TO_CHAR(T.INSERT_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
                                EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES_T';
								EXECUTE IMMEDIATE Q'['DELETE FROM DBXNET.CREDITRECEIVABLES_DUMP WHERE TO_CHAR(SYSDATE, 'DDMMYYYY') - TO_CHAR(CURRENT_TIMESTAMP, 'DDMMYYYY') > 30']';
                                COMMIT;
                        ELSE
                                EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('COUNT OF TEMP TABLE <> MAIN TABLE ERROR IN INSERTION')]';
                                COMMIT;
                        END IF;
                EXCEPTION
                        -- HANDLES ALL ERRORS
                        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION IN POPULATE_CR');
                        EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR')]';
                        COMMIT;
                END POPULATE_CR;
END CREDIT_RECEIVABLES;
---------------------------------------------------------------------------------------
--view
-- DBXNET.CREDIT_RECEIVABLES_V source

CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "DBXNET"."CREDIT_RECEIVABLES_V" ("SAP_CUST_NUMBER", "DOC_NUMBER", "DOC_DATE", "AMOUNT", "CURRENCY", "TRX_TYPE", "DOC_TYPE", "ASSIGNEMNET_NUM", "NET_DUE_DATE", "CREDIT_SEQ") AS 
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
        CR.SAP_CUST_NUMBER = B.SAP_CUST_NUMBER;
---------------------------------------------------------------------------------------------------------

---SCHEDULER:
BEGIN 
   dbms_scheduler.create_job ( 
    job_name => 'POPULATE_CR_BACK', 
    job_type => 'PLSQL_BLOCK', 
    job_action => 'DECLARE BEGIN DBXNET.CREDIT_RECEIVABLES.POPULATE_CR_BACK_UP(); END;', 
    start_date => SYSTIMESTAMP, 
    enabled => true, 
    repeat_interval => 'FREQ=DAILY; byhour=20; byminute=0; bysecond=0;'
   ); 
END;
-------------------------------------------------------------------------------------------------
BEGIN 
   dbms_scheduler.create_job ( 
    job_name => 'POPULATE_CR_MAIN', 
    job_type => 'PLSQL_BLOCK', 
    job_action => 'DECLARE BEGIN DBXNET.CREDIT_RECEIVABLES.POPULATE_CR(); END;', 
    start_date => SYSTIMESTAMP, 
    enabled => true, 
    repeat_interval => 'FREQ=DAILY; byhour=21; byminute=0; bysecond=0;'
   ); 
END;
----------------------------------------------------------------------------------------------------
SELECT LOG_DATE, JOB_NAME, STATUS, RUN_DURATION
FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME='POPULATE_CR_MAIN' order by log_date desc;
--OR STATUS='FAILED';

SELECT * FROM ALL_SCHEDULER_JOBS; --FOR A LIST OF ALL SCHEDULER JOBS.
--SELECT * FROM DBA_SCHEDULER_JOBS’ IF YOU HAVE DBA PRIVILEGES
-----------------------------------------------------------------------------------------------------
BEGIN
   dbms_scheduler.run_job('POPULATE_CR_MAIN');
END;
----------------------------------------------------------------------------------------------------
DECLARE
        BEGIN
                DBXNET.CREDIT_RECEIVABLES.POPULATE_CR();
                
        END;
-----------------------------------------------------------------------------------------------------------
BEGIN
  dbms_scheduler.drop_job(job_name => 'POPULATE_CR_MAIN');
END;
-----------------------------------------------------------------------------------------------------
SELECT * FROM DBXNET.CREDITRECEIVABLES_T ;
SELECT * FROM DBXNET.CREDITRECEIVABLES; 
SELECT * FROM DBXNET.CREDITRECEIVABLES_B;
SELECT * FROM DBXNET.CREDITRECEIVABLES_DUMP;
SELECT * FROM DBXNET.CREDIT_RECEIVABLES_V;
----------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_T ;
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES; 
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_B;
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_DUMP;
SELECT COUNT(*) FROM DBXNET.CREDIT_RECEIVABLES_V;
---------------------------------------------------------------TESTING-------------------------------------------------------------

DECLARE
BEGIN
   dbms_scheduler.run_job('POPULATE_CR_BACK');
END;
-----------------------------------------------------------------------------------------------------
DECLARE
BEGIN
   dbms_scheduler.run_job('POPULATE_CR_MAIN');
END;
-------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
SELECT * FROM DBXNET.CREDITRECEIVABLES_T ;
SELECT * FROM DBXNET.CREDITRECEIVABLES; 
SELECT * FROM DBXNET.CREDITRECEIVABLES_B;
SELECT * FROM DBXNET.CREDITRECEIVABLES_DUMP;
SELECT * FROM DBXNET.CREDIT_RECEIVABLES_V;
----------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_T ;
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES; 
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_B;
SELECT COUNT(*) FROM DBXNET.CREDITRECEIVABLES_DUMP;
SELECT COUNT(*) FROM DBXNET.CREDIT_RECEIVABLES_V;
----------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
v_t NUMBER := 0;
v_m NUMBER := 0;
v_b NUMBER := 0;
v_d NUMBER := 0;
v_v NUMBER := 0;
BEGIN

SELECT COUNT(*) into v_t FROM DBXNET.CREDITRECEIVABLES_T ;
SELECT COUNT(*) into v_m FROM DBXNET.CREDITRECEIVABLES; 
SELECT COUNT(*) into v_b FROM DBXNET.CREDITRECEIVABLES_B;
SELECT COUNT(*) into v_d FROM DBXNET.CREDITRECEIVABLES_DUMP;
SELECT COUNT(*) into v_v FROM DBXNET.CREDIT_RECEIVABLES_V;

DBMS_OUTPUT.PUT_LINE ('COUNT PRESENT IN TEMP TABLE'||'='||v_t);
DBMS_OUTPUT.PUT_LINE ('COUNT PRESENT IN MAIN TABLE'||'='||v_m);
DBMS_OUTPUT.PUT_LINE ('COUNT PRESENT IN BACK-UP TABLE'||'='||v_b);
DBMS_OUTPUT.PUT_LINE ('COUNT PRESENT IN DUMP TABLE'||'='||v_d);
DBMS_OUTPUT.PUT_LINE ('COUNT PRESENT IN CR VIEW'||'='||v_v);

END;
---------------------------------------------------------------------------------------------------------------------------