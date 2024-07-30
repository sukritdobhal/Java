https://stackoverflow.com/questions/14016842/how-to-schedule-a-work-to-run-at-particular-time-using-dbms-scheduler
-----------------------------------------------------------------
https://stackoverflow.com/questions/7188626/dbms-scheduler-run-jobjobname-fails-to-run
-------------------------------------------------------------------------------------------

--*******************************************************
--/*from here ORA-00054: resource busy
--and acquire with NOWAIT specified You can also look up the sql,username,machine,port information
--and
--get to the actual process which holds the connection*/
SELECT
        O.OBJECT_NAME,
        S.SID        ,
        S.SERIAL#    ,
        P.SPID       ,
        S.PROGRAM    ,
        S.USERNAME   ,
        S.MACHINE    ,
        S.PORT       ,
        S.LOGON_TIME ,
        SQ.SQL_FULLTEXT
FROM
        V$LOCKED_OBJECT L,
        DBA_OBJECTS O    ,
        V$SESSION S      ,
        V$PROCESS P      ,
        V$SQL SQ
WHERE
        L.OBJECT_ID   = O.OBJECT_ID
AND     L.SESSION_ID  = S.SID
AND     S.PADDR       = P.ADDR
AND     S.SQL_ADDRESS = SQ.ADDRESS;
-----------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE DBXNET.CREDIT_RECEIVABLES
AS
        PROCEDURE POPULATE_CR_BACK_UP;
        PROCEDURE POPULATE_CR;
END CREDIT_RECEIVABLES;
CREATE OR REPLACE PACKAGE BODY DBXNET.CREDIT_RECEIVABLES
AS
        /*
        Purpose:      Package handles CR Logic
        Remarks:
        Who     Date        Description
        ------  ----------  --------------------------------
        Sukrit   12.07.2023  Created
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
                                DBMS_Output.PUT_LINE ('DATA PRESENT IN MAIN TABLE');
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
                                        DBMS_Output.PUT_LINE ('COUNT OF CR TABLE = COUNT OF BACKUP TABLE');
                                        EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES';
                                        COMMIT;
                                ELSE
                                        EXECUTE IMMEDIATE q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('COUNT OF MAIN TABLE <> BACKUP TABLE')]';
                                        COMMIT;
                                END IF;
                        ELSE
                                EXECUTE IMMEDIATE q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('NO DATA IN MAIN TABLE')]';
                                COMMIT;
                        END IF;
                EXCEPTION
                        -- Handles all errors
                        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION IN POPULATE_CR_BACK_UP');
                        EXECUTE IMMEDIATE q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR_BACK_UP')]';
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
                                DBMS_Output.PUT_LINE ('COUNT OF TEMP TABLE = COUNT OF CR TABLE');
                                EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.CREDITRECEIVABLES_T';
                                COMMIT;
                        ELSE
                                EXECUTE IMMEDIATE q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('COUNT OF TEMP TABLE <> MAIN TABLE ERROR IN INSERTION')]';
                                COMMIT;
                        END IF;
                EXCEPTION
                        -- Handles all errors
                        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('EXCEPTION IN POPULATE_CR');
                        EXECUTE IMMEDIATE q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN POPULATE_CR')]';
                        COMMIT;
                END POPULATE_CR;
END CREDIT_RECEIVABLES;
--------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE
        BEGIN
                DBXNET.CREDIT_RECEIVABLES.POPULATE_CR();
                
        END;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
alter session set DDL_LOCK_TIMEOUT = 20;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        V$SESSION
WHERE
        STATUS = 'ACTIVE';
------------------------------------------------------------------------------------------------------------------------------------------------------------
alter session set DDL_LOCK_TIMEOUT = 20;
SELECT
        *
FROM
        V$SESSION
WHERE
        STATUS = 'ACTIVE'; --4157
alter system kill session 'SID,SERIAL#';
alter system kill session '4157,54478';
SELECT
        *
FROM
        V$OPEN_CURSOR
WHERE
        SID = 4157;
--ORA-00027: Cannot Kill Current Session
--Get the sid and serial# for the current session
select
        username,
        inst_id ,
        sid     ,
        serial#
FROM
        gV$SESSION
WHERE
        audsid = userenv('sessionid');
--Now  open another fresh session and run the ALTER SYSTEM KILL statement, it will execute successfully.
alter system kill session '242,13' immediate;
TRUNCATE TABLE DBXNET.CREDITRECEIVABLES;
SELECT
        a.sid,
        a.serial#
from
        v$session a      ,
        v$locked_object b,
        dba_objects c
where
        b.object_id = c.object_id
and     a.sid       = b.session_id
AND     OBJECT_NAME = 'CREDITRECEIVABLES'; --2688 53431
alter system kill session '2688,53431' immediate;
SELECT
        *
FROM
        V$SESSION
WHERE
        STATUS = 'ACTIVE';
SELECT
        *
FROM
        V$OPEN_CURSOR
where
        sql_text like '%persad_d%'; --2868
select
        username,
        inst_id ,
        sid     ,
        serial#
FROM
        gV$SESSION
WHERE
        sid = 2868; -- serial 52286
alter system kill session '2868,52286';
ALTER SESSION SET current_schema = DBXNET;
select
        *
from
        v$session
where
        sid in
        (
                select
                        session_id
                from
                        dba_dml_locks
                where
                        name = 'PERSAD_D');
---------------------------------------------------------------------------------------------------------------------------------------------------------------
alter session set "_ORACLE_SCRIPT"=true;
CREATE USER SUKRIT IDENTIFIED BY SUKRIT;
https://stackoverflow.com/questions/67368681/how-to-export-schema-and-import-it-to-another-schema-in-pl-sql-developer
https://stackoverflow.com/questions/33330968/error-ora-65096-invalid-common-user-or-role-name-in-oracle-database
SQL>
show con_name CON_NAME------------------------------
CDB$ROOT SQL>
show pdbs CON_ID CON_NAME OPEN MODE RESTRICTED
---------- ------------------------------ ---------- ----------
2 PDB$SEED READ ONLY NO 3 XEPDB1 READ WRITE NO SQL> alter session set container = XEPDB1;
Session altered. SQL                              >
SHOW CON_NAME;
CON_NAME------------------------------
XEPDB1 SQL> CREATE USER DBXNET;
User created.
If
        your goal is to create an Oracle user
        and
then
        use it to do stuff with your DB you probably want to consider doing this: log as sysdba create a pdb (a.k.a. pluggable database) create a user for your pdb What follows assume you are working with a db in localhost,
        if
                not simply
                change "localhost" with your db uri. Sample code Log as sysdba: $ sqlplus sys/<your_admin_pws>@localhost as sysdba
        then
                execute this: create pluggable database MYDATABASE admin user Scott identified by tiger;
                file_name_convert = ('/pdbseed/', '/mydatabase/');
                alter pluggable database MYDATABASE open;
        then
                you may want to grant some permission to user Scott: log out from @localhost
                and log back in as sysdba to your new db $ sqlplus sys/<your_admin_pws>@localhost/MYDATABASE as sysdba
                and grant Scott whatever permission you want, e.g. grant
                connect to Scott;
                grant
                create view to Scott;
                grant
                create table to Scott;
                grant
                create trigger to Scott;
                now you are good to go: you have an empty database instance
                and a user. Just log                       in by doing $ sqlplus Scott/tiger@localhost/MYDATABASE Bonus I had problem with tablespaces
                and quotas after that. Log with sqlplus sys/<your_admin_pws>@localhost/MYDATABASE as sysdba You can
                list all tablespaces with
                SELECT
                        TABLESPACE_NAME,
                        STATUS         ,
                        CONTENTS
                FROM
                        USER_TABLESPACES;
                You can create a new tablespace with CREATE TABLESPACE TABLESPACENAME DATAFILE 'tablespace_datafile.dat' SIZE 10M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 200M;
                You can drop your broken tablespaces with Drop tablespace TABLESPACENAME including contents
                and datafiles;
                You can grant "access" to the tablespace to Scott with alter user Scott quota unlimited on TABLESPACENAME;
                N.B. quota unlimited is probably a bad practice, check oracle docs on how to limit users quota----------------------------------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        banner
                FROM
                        v$version
                WHERE
                        ROWNUM = 1;
                --------------------------------------------------------------------------------------------------------------------------------------------------------------
                --SQL> show con_name
                --CON_NAME
                ------------------------------
                ----CDB$ROOT
                --SQL> show pdbs
                --  CON_ID CON_NAME                       OPEN MODE  RESTRICTED
                ---------- ------------------------------ ---------- ----------
                --         2 PDB$SEED                       READ ONLY  NO
                --        3 XEPDB1                         READ WRITE NO
                ALTER SESSION SET CONTAINER =XEPDB1;
                CREATE USER HR2 IDENTIFIED BY HR2;
                -----------------------------------------------------------------------------------------------------------------------------------------------------------
                sqlplus /@TNS_ALIAS @EXEC script.sql-----------------------------------------------------------------------------------------------------------------------------------------------------------
                C:\app\sdobhal\product\21c\homes\OraDB21Home1\network\admin\listener.ora-----------------------------------------------------------------------------------------------------------------------------------------------------
                localhost:8080\Portal_2.9-------------------------------------------------------------------------------------------------------------------------------------------------------
                CREATE
                OR REPLACE EDITIONABLE TRIGGER "DBXNET"."AUPO_D_TRIGG"
                BEFORE INSERT ON DBXNET.AUPO_D
                FOR EACH ROW
                BEGIN
                        SELECT
                                AUPO_D_SEQ.NEXTVAL
                        INTO
                                :NEW.AUPO_SEQ
                        FROM
                                DUAL;
                END;
        /
        ALTER TRIGGER "DBXNET"."AUPO_D_TRIGG" ENABLE;
        CREATE SEQUENCE DBXNET.AUPO_D_SEQ INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER;
        CREATE SEQUENCE DBXNET.AUPO_D_SEQ_NEW;
        SELECT
                setval('book_id_seq', (
                        SELECT
                                MAX(id) + 1
                        FROM
                                book.book));
        ALTER SEQUENCE DBXNET.AUPO_D_SEQ restart
        start with 5182999;
        ---------------------------------------------------------------------------------------------------------------------------------------------------------
        --Change data type of column
        ALTER TABLE DBXNET.KD01_D ADD VERT_NR_NEW VARCHAR2(200);
        INSERT INTO
                DBXNET.KD01_D
                        (
                                VERT_NR_NEW
                        )
        SELECT
                VERT_NR
        FROM
                DBXNET.KD01_D;
        COMMIT;
        ALTER TABLE DBXNET.KD01_D DROP
        COLUMN VERT_NR;
        ALTER TABLE DBXNET.KD01_D RENAME
        COLUMN VERT_NR_NEW TO VERT_NR;
        COMMIT;
        SELECT
                VERT_NR
        FROM
                DBXNET.KD01_D
        WHERE
                VERT_NR IS NOT NULL;
        -------------------------------------------------------------------------------------------------------------------------------------------------------------
        CREATE SEQUENCE pop_seq
        START WITH 1 INCREMENT BY 1 CACHE 20;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------
        SELECT
                C.TABLE_NAME                ,
                C.CONSTRAINT_NAME           ,
                C.CONSTRAINT_TYPE           ,
                C.STATUS                    ,
                C.R_OWNER                   ,
                C.R_CONSTRAINT_NAME         ,
                C.TABLE_NAME AS R_TABLE_NAME,
                C.DELETE_RULE               ,
                COL.COLUMN_NAME             ,
                COL.POSITION
        FROM
                ALL_CONSTRAINTS C   ,
                ALL_CONS_COLUMNS COL,
                ALL_CONSTRAINTS RC
        WHERE
                C.CONSTRAINT_TYPE  = 'R'
        AND     C.OWNER            = 'OWNER'
        AND     C.OWNER            = COL.OWNER
        AND     C.CONSTRAINT_NAME  = COL.CONSTRAINT_NAME
        AND     RC.OWNER           = C.R_OWNER
        AND     RC.CONSTRAINT_NAME = C.R_CONSTRAINT_NAME
        AND     C.TABLE_NAME       = 'TABLE'
        ORDER BY
                C.CONSTRAINT_NAME,
                COL.POSITION;
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------
        CREATE
        OR REPLACE EDITIONABLE TRIGGER "DBXNET"."XNVA_D_TRIGG"
        BEFORE INSERT ON DBXNET.XNVA_D
        FOR EACH ROW
        BEGIN
                SELECT
                        XNVA_D_SEQ.NEXTVAL
                INTO
                        :NEW.ORDAT_SEQUENCE
                FROM
                        DUAL;
        END;
/
ALTER TRIGGER "DBXNET"."XNVA_D_TRIGG" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
SLBK_D:
INSERT INTO
        DBXNET.SLBK_D
                (
                        BENUTZERX12    ,
                        FA_NR          ,
                        KTO_NR         ,
                        TEILENR        ,
                        ALTE_TEILENR   ,
                        UTNR           ,
                        POS_ART_KZ     ,
                        VKBEREICH      ,
                        SET_MENGE      ,
                        AUF_MENGE      ,
                        VK_PR_FW       ,
                        NET_PR_FW      ,
                        BEMERKUNG      ,
                        LETZT_AEND     ,
                        STATUS_KZ      ,
                        KENNZLX4       ,
                        VKEH           ,
                        LISTUNG        ,
                        VG_NR_LG3      ,
                        LI_TER_TAG     ,
                        TIMESTAMP_RESV ,
                        TEILEBEZ1      ,
                        SPR_SL         ,
                        LI_TER_TAG_2   ,
                        LI_TER_TAG_TX  ,
                        LI_TER_TAG_TX_2,
                        LORT           ,
                        GBUB           ,
                        PREISLISTE     ,
                        SAP_CUST_NUMBER,
                        SALES_ORG
                )
VALUES
        (
                'SUKRITTEST1',
                ''           ,
                0            ,
                'SUKRITTEST' ,
                'SUKRITTEST' ,
                ''           ,
                'AB'         ,
                ''           ,
                1            ,
                1            ,
                1            ,
                1            ,
                ''           ,
                19990101     ,
                0            ,
                ''           ,
                0            ,
                'ABC'        ,
                ''           ,
                0            ,
                0            ,
                ''           ,
                2            ,
                0            ,
                ''           ,
                ''           ,
                ''           ,
                'GB'         ,
                ''           ,
                ''           ,
                ''
        )
;
SELECT
        *
FROM
        SLBK_D sd
WHERE
        SYSDATE     - to_date(sd.letzt_aend,'YYYYMMDD') > 21
AND     BENUTZERX12 IN ('SUKRITTEST1')
ORDER BY
        LETZT_AEND DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
https://stackoverflow.com/questions/61623142/sql-nvl-on-multiple-tables-columns
---------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE
        BEGIN
                EXECUTE IMMEDIATE 'alter session set current_schema = DBXNET';
                CREDIT_RECEIVABLES.POPULATE_CR_BACK_UP;
        END;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        AUPO_D
WHERE
        AUPO_SEQ IN
        (
                SELECT
                        AUPO_SEQ
                FROM
                        AUPO_D
                GROUP BY
                        AUPO_SEQ
                HAVING
                        COUNT(AUPO_SEQ) >=2)
ORDER BY
        AUPO_SEQ DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
DELETE
FROM
        AUPO_D C
WHERE
        C.AUPO_SEQ IN
        (
                SELECT
                        A.AUPO_SEQ
                FROM
                        AUPO_D A
                WHERE
                        A.AUPO_SEQ IN
                        (
                                SELECT
                                        B.AUPO_SEQ
                                FROM
                                        AUPO_D B
                                GROUP BY
                                        B.AUPO_SEQ
                                HAVING
                                        COUNT(B.AUPO_SEQ) >=2));
----------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE CUSTOMERRECEIVABLES ADD INSERT_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        TO_CHAR(INSERT_DATE, 'YYYY-MM-DD')
FROM
        FRED.CUSTOMERRECEIVABLES;
select
        to_char(cast(sysdate as date),'DD-MM-YYYY
')
from
        dual;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
sqlplus sys/<pwd> SQL> @$ORACLE_HOME/rdbms/admin/utlmail.sql SQL> @$ORACLE_HOME/rdbms/admin/prvtmail.plb--------------------------------------------------------------------------------------------------------------------------------------------------------------
DELETE
FROM
        SLBK_D
WHERE
        BENUTZERX12 = 'abdulT'
AND     teilenr NOT IN ('DW677                                                                                                                                                                                                                                                                                                                                                                                                                -QS',
                       '034158-00');
UPDATE
        persad_d
SET
        sap_cust_number = NULL
WHERE
        FA_KTO_NR IN
        (
                SELECT
                        FA_KTO_NR
                FROM
                        IGAK_D);
CREATE SEQUENCE SEQ_TEST_TABLE
START WITH 80000000 INCREMENT BY 1 MINVALUE 1 NOMAXVALUE NOCYCLE CACHE 2;
UPDATE
        PERSAD_D
SET
        SAP_CUST_NUMBER = SEQ_TEST_TABLE.NEXTVAL
WHERE
        FA_KTO_NR IN
        (
                SELECT
                        FA_KTO_NR
                FROM
                        IGAK_D);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
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
ROLLBACK;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
FROM
        DUAL;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
Select
        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
from
        dual;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        sum(bytes)/1024/1024 AS "Database Size (MB)"
FROM
        dba_data_files;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ORG_CODE_LINK
        (P_SALES_ORG VARCHAR2)
IS
        GUTB_count   NUMBER;
        SW_count     NUMBER;
        MI_count     NUMBER;
        CH_count     NUMBER;
        PL_count     NUMBER;
        AU_count     NUMBER;
        DK_count     NUMBER;
        HU_count     NUMBER;
        NL_count     NUMBER;
        FR_count     NUMBER;
        TOTAL_count  NUMBER;
        GUTB_PERCENT NUMBER(9,2);
        SW_PERCENT   NUMBER(9,2);
        MI_PERCENT   NUMBER(9,2);
        CH_PERCENT   NUMBER(9,2);
        PL_PERCENT   NUMBER(9,2);
        AU_PERCENT   NUMBER(9,2);
        DK_PERCENT   NUMBER(9,2);
        HU_PERCENT   NUMBER(9,2);
        NL_PERCENT   NUMBER(9,2);
        FR_PERCENT   NUMBER(9,2);
BEGIN
        SELECT
                COUNT(*)
        INTO
                TOTAL_count
        FROM
                COMPANY_CODE
        WHERE
                SAP_SALES_ORG = P_SALES_ORG
        AND     LEGACY_COMPANY_CODE IS NOT NULL;
        DBMS_OUTPUT.PUT_LINE('TOTAL COUNT FOR'||' '||P_SALES_ORG||' '||'='||TOTAL_count);
        --------------------------------------------------------------------------------------------------------------------------
        IF
                 (TOTAL_count > 0)
        THEN
                SELECT
                        COUNT(*)
                INTO
                        GUTB_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'GUTB';
                GUTB_PERCENT := (GUTB_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR GUTB AND'||' '||P_SALES_ORG||' '||'='||GUTB_PERCENT);
                ---------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        SW_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'SW';
                SW_PERCENT := (SW_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR SW AND'||' '||P_SALES_ORG||' '||'='||SW_PERCENT);
                --------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        MI_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'MI';
                MI_PERCENT := (MI_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR MI AND'||' '||P_SALES_ORG||' '||'='||MI_PERCENT);
                -------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        CH_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'CH';
                CH_PERCENT := (CH_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR CH AND'||' '||P_SALES_ORG||' '||'='||CH_PERCENT);
                -------------------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        PL_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'PL';
                PL_PERCENT := (PL_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR PL AND'||' '||P_SALES_ORG||' '||'='||PL_PERCENT);
                -----------------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        AU_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'AU';
                AU_PERCENT := (AU_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR AU AND'||' '||P_SALES_ORG||' '||'='||AU_PERCENT);
                ----------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        DK_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'DK';
                DK_PERCENT := (DK_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR DK AND'||' '||P_SALES_ORG||' '||'='||DK_PERCENT);
                -----------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        HU_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'HU';
                HU_PERCENT := (HU_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR HU AND'||' '||P_SALES_ORG||' '||'='||HU_PERCENT);
                -------------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        NL_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'NL';
                NL_PERCENT := (NL_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR NL AND'||' '||P_SALES_ORG||' '||'='||NL_PERCENT);
                -------------------------------------------------------------------------------------------------------------------------------------------------
                SELECT
                        COUNT(*)
                INTO
                        FR_count
                FROM
                        COMPANY_CODE
                WHERE
                        SAP_SALES_ORG       = P_SALES_ORG
                AND     LEGACY_COMPANY_CODE = 'FR';
                FR_PERCENT := (FR_count/TOTAL_count) * 100;
                DBMS_OUTPUT.PUT_LINE('PERCENT FOR FR AND'||' '||P_SALES_ORG||' '||'='||FR_PERCENT);
                ---------------------------------------------------------------------------------------------------------------------------------------------------
                IF
                         (GUTB_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO GUTB');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'GUTB'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (SW_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO SW');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'SW'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (MI_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO MI');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'MI'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (CH_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO CH');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'CH'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (PL_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO PL');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'PL'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (AU_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO AU');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'AU'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (DK_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO DK');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'DK'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (HU_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO HU');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'HU'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (NL_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO NL');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'NL'
                                )
                        ;
                        COMMIT;
                ELSIF
                        (FR_PERCENT >= 90)
                THEN
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN BE LINKED TO FR');
                        INSERT INTO
                                ORG_CODE
                        VALUES
                                (
                                        P_SALES_ORG,
                                        'FR'
                                )
                        ;
                        COMMIT;
                ELSE
                        DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' CAN NOT BE DIRECTLY LINKED TO ANY LEGACY COMPANY CODE');
                END IF;
        ELSE
                DBMS_OUTPUT.PUT_LINE(P_SALES_ORG||''|| ' HAS ZERO ROWS');
        END IF;
END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE  TYPE t_people
IS
        TABLE OF varchar2(10) INDEX BY PLS_INTEGER;
        arrayvalues t_people;
BEGIN
        SELECT DISTINCT
                (SAP_SALES_ORG) BULK COLLECT
        INTO
                arrayvalues
        FROM
                COMPANY_CODE;
        FOR i IN 1 .. arrayvalues.COUNT
        LOOP dbms_output.put_line(arrayvalues(i));
                ORG_CODE_LINK(arrayvalues(i));
        END LOOP;
END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE  TYPE t_people
IS
        TABLE OF varchar2(10) INDEX BY PLS_INTEGER;
        arrayvalues t_people;
BEGIN
        SELECT
                * BULK COLLECT
        INTO
                arrayvalues
        FROM
                (
                        select
                                'Matt' m_value
                        from
                                dual
                        
                        union all
                        
                        select
                                'Joanne'
                        from
                                dual
                        
                        union all
                        
                        select
                                'Robert'
                        from
                                dual );
        --
        FOR i IN 1 .. arrayvalues.COUNT
        LOOP dbms_output.put_line(arrayvalues(i)||' is my friend');
        END LOOP;
END;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER USER DBXNET quota unlimited on USERS;
select
        table_name,
        tablespace_name
from
        all_tables
where
        owner = 'DBXNET';
----------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE a NUMBER;
b         NUMBER;
        BEGIN
                a := :a; --this will take input from user
                b := :b;
                DBMS_OUTPUT.PUT_LINE('a = '|| a);
                DBMS_OUTPUT.PUT_LINE('b = '|| b);
        END;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
https://stackoverflow.com/questions/12516930/how-to-get-input-from-user-at-runtime
----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        VE    ,
        KTO_NR,
        STAT_KZ
FROM
        DBAUFT.KD01_D
WHERE
        VE IN
        (
                SELECT DISTINCT
                        (VEEH)
                FROM
                        DBXNET.ULI_M A
                WHERE
                        SYSDATE - to_date(A.LAST_LOGON ,'YYYYMMDD') < = 365
                AND     VEEH IS NOT NULL
                AND     KTO_NR IN
                        (
                                SELECT
                                        KTO_NR
                                FROM
                                        DBXNET.KTEMP)
                
                INTERSECT
                
                SELECT
                        VE
                FROM
                        DBAUFT.KD01_D
                GROUP BY
                        VE
                HAVING
                        COUNT(VE) > 1)
ORDER BY
        VE;
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        DBXNET.IAK_D
WHERE
        BENUTZERX12 IN
        (
                SELECT
                        BENUTZER
                FROM
                        DBXNET.ULI_M A
                WHERE
                        TRUNC(SYSDATE) - to_date(TO_CHAR(NVL(A.LAST_LOGON,'20240119')),'YYYYMMDD') < = 365
                AND     A.LAST_LOGON                                                               > 20230101);
--------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        VE    ,
        KTO_NR,
        STAT_KZ
FROM
        DBAUFT.KD01_D
WHERE
        VE IN
        (
                SELECT DISTINCT
                        (VEEH)
                FROM
                        DBXNET.ULI_M A
                WHERE
                        TRUNC(SYSDATE) - to_date(TO_CHAR(NVL(A.LAST_LOGON,'20240119')),'YYYYMMDD') < = 365
                AND     A.LAST_LOGON                                                               >20230101
                AND     VEEH IS NOT NULL
                AND     KTO_NR IN
                        (
                                SELECT
                                        KTO_NR
                                FROM
                                        DBXNET.KTEMP)
                
                INTERSECT
                
                SELECT
                        VE
                FROM
                        DBAUFT.KD01_D
                GROUP BY
                        VE
                HAVING
                        COUNT(VE) > 1)
AND     KTO_NR IN
        (
                SELECT
                        KTO_NR
                FROM
                        DBAUFT.AUKO_D A
                WHERE
                        TRUNC(SYSDATE) - to_date(TO_CHAR(NVL(A.AUF_DAT, '20240119')), 'YYYYMMDD') <= 365
                AND     A.AUF_DAT                                                                 > 20230101)
ORDER BY
        VE;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        VE    ,
        KTO_NR,
        STAT_KZ
FROM
        DBAUFT.KD01_D
WHERE
        VE IN
        (
                SELECT DISTINCT
                        (VEEH)
                FROM
                        DBXNET.ULI_M A
                WHERE
                        TRUNC(SYSDATE) - to_date(TO_CHAR(NVL(A.LAST_LOGON,'20240119')),'YYYYMMDD') < = 365
                AND     A.LAST_LOGON                                                               >20230101
                AND     VEEH IS NOT NULL
                AND     KTO_NR IN
                        (
                                SELECT
                                        KTO_NR
                                FROM
                                        DBXNET.KTEMP)
                
                INTERSECT
                
                SELECT
                        VE
                FROM
                        DBAUFT.KD01_D
                GROUP BY
                        VE
                HAVING
                        COUNT(VE) > 1)
AND     KTO_NR IN
        (
                SELECT
                        SUBSTR(A.FA_KTO_NR, 7, 10)
                FROM
                        DBXNET.IAK_D A
                WHERE
                        TRUNC(SYSDATE) - to_date(TO_CHAR(NVL(A.LAST_MOD_DATE,'20240119')),'YYYYMMDD') < = 365
                AND     A.LAST_MOD_DATE                                                               > 20230101)
ORDER BY
        VE;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        DBXNET.MATERIALMASTER_LP;
COMMIT;
--DUPLICATE DELETE------
DELETE
FROM
        DBXNET.MATERIALMASTER_LP
WHERE
        rowid not in
        (
                SELECT
                        MIN(rowid)
                FROM
                        DBXNET.MATERIALMASTER_LP
                GROUP BY
                        PARTS_NUMBER,
                        LANGUAGE_CODE);
ALTER TABLE DBXNET.MATERIALMASTER_LP ADD PRIMARY KEY (PARTS_NUMBER, LANGUAGE_CODE);
--------------------------------------------------------------------------------------------------------------------------------------------------------