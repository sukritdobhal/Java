https://oracle-base.com/articles/10g/dml-error-logging-10gr2
-------------------------------------------------------------------------------
https://stackoverflow.com/questions/40150208/how-to-efficiently-check-if-two-columns-in-the-same-table-is-one-to-one-mapping
-----------------------------------------------------------------------------
---------------------------------------------------------------------
CREATE TABLE DBXNET.SLBK_D_BCK AS
SELECT
        *
FROM
        DBXNET.SLBK_D;
-------------------------------------------------------------------
UPDATE
        DBXNET.SLBK_D
SET
        VERTRETER = NULL;
------------------------------------------------------------------
ALTER TABLE DBXNET.SLBK_D MODIFY VERTRETER VARCHAR2(200);
------------------------------------------------------------------
BEGIN
        FOR I IN
        (
                SELECT
                        ORDAT_SEQUENCE,
                        VERTRETER
                FROM
                        DBXNET.SLBK_D_BCK)
        LOOP
                UPDATE
                        DBXNET.SLBK_D
                SET
                        VERTRETER = I.VERTRETER
                WHERE
                        ORDAT_SEQUENCE = I.ORDAT_SEQUENCE;
        END LOOP;
END;
-----------------------------------------------------------------
COMMIT;
-----------------------------------------------------------------
DROP TABLE DBXNET.SLBK_D_BCK;
----------------------------------------------------------------
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
        LOOP
                DBMS_OUTPUT.put_line (l_customers (indx));
                UPDATE
                        DBXNET.IGAK_D D
                SET
                        D.SAP_CUST_NUMBER = l_customers(indx)
                WHERE
                        SUBSTR (D.FA_KTO_NR, 7, 10) = CAST(l_numbers(indx) AS VARCHAR2 (200));
                COMMIT;
        END LOOP;
END POPULATE_IGAK;
--------------------------------------------------------------------------------
BEGIN
        FOR I IN
        (
                SELECT
                        T2.SAP_CUST_NUMBER,
                        T2.KTO_NR
                FROM
                        DBXNET.IGAK_D T1
                JOIN
                        DBXNET.SAPCUST_KTO_MAP T2
                ON
                        CAST(T2.KTO_NR AS VARCHAR2 (200)) = SUBSTR (T1.FA_KTO_NR, 7, 10))
        LOOP
                UPDATE
                        DBXNET.IGAK_D
                SET
                        SAP_CUST_NUMBER = I.SAP_CUST_NUMBER
                WHERE
                        SUBSTR (FA_KTO_NR, 7, 10) = I.KTO_NR;
        END LOOP;
END;
-----------------------------------------------
SELECT
        *
FROM
        V$SESSION
WHERE
        SID IN
        (
                SELECT
                        SESSION_ID
                FROM
                        DBA_DML_LOCKS
                WHERE
                        NAME = 'IGAK_D');
alter system kill session '3018,38575';
------------------------------------------------------------------------
DROP INDEX first_name_idx;
CREATE INDEX first_name_idx
ON user_data
        (
                gender           ,
                UPPER(first_name),
                dob
        )
;
EXEC DBMS_STATS.gather_table_stats(USER       ,
                                   'user_data',
                                   cascade => TRUE);
-----------------------------------------------------------------------------
BEGIN
        DBMS_MONITOR.SESSION_TRACE_ENABLE ( SESSION_ID     => <SID>    ,
                                            SERIAL_NUM     => <SERIAL#>,
                                            WAITS          => TRUE     ,
                                            BINDS          =>          ,
                                            TRUE PLAN_STAT => 'ALL_EXECUTIONS');
END;
--------------------------------------------------------------------------------
--https://blogs.oracle.com/connect/post/beginning-performance-tuning-trace-your-steps
--------------------------------------------------------------------------------------
TKPROF ANN1_ORA_11408.TRC ANN1_ORA_11408.OUT SYS=NO WAITS=YES AGGREGATE=NO WIDTH=180-------------------------------------------------------------------------------------
CREATE TABLE DBXNET.IGAK_POP AS
SELECT
        ORDERID,
        SUBSTR (FA_KTO_NR,
        7                ,
        10) AS KTO_NR
FROM
        DBXNET.IGAK_D;
----------------------------------------------------------------------------------------
CREATE TABLE DBXNET.IGAK_POP AS
SELECT
        ORDERID,
        SUBSTR (FA_KTO_NR,
        7                ,
        10) AS KTO_NR
FROM
        DBXNET.IGAK_D;
ALTER TABLE DBXNET.IGAK_POP ADD SAP_CUST_NUMBER VARCHAR2(200);
CREATE TABLE DBXNET.IGAK_POP_B AS
SELECT
        *
FROM
        DBXNET.IGAK_POP;
SELECT
        *
FROM
        DBXNET.IGAK_POP_B;
UPDATE
        DBXNET.IGAK_POP
SET
        KTO_NR = NULL;
COMMIT;
ALTER TABLE DBXNET.IGAK_POP MODIFY KTO_NR NUMBER(10,0);
ALTER TABLE DBXNET.IGAK_POP_B ADD KTO_NR1 NUMBER(10,0);
UPDATE
        DBXNET.IGAK_POP_B
SET
        KTO_NR1 = KTO_NR;
ALTER TABLE DBXNET.IGAK_POP_B DROP
COLUMN KTO_NR;
ALTER TABLE DBXNET.IGAK_POP_B RENAME
COLUMN KTO_NR1 TO KTO_NR;
UPDATE
        DBXNET.IGAK_POP
SET
        KTO_NR =
        (
                SELECT
                        KTO_NR
                FROM
                        DBXNET.IGAK_POP_B
                WHERE
                        ORDERID IN
                        (
                                SELECT
                                        ORDERID
                                FROM
                                        DBXNET.IGAK_POP));
UPDATE
        DBXNET.IGAK_POP P
SET
        P.SAP_CUST_NUMBER =
        (
                SELECT
                        S.SAP_CUST_NUMBER S
                FROM
                        DBXNET.SAPCUST_KTO_MAP
                WHERE
                        S. KTO_NR AS VARCHAR2) = P.KTO_NR);
SELECT
        *
FROM
        DBXNET.IGAK_POP;
-------------------------------------------------------------------------------------------
BEGIN
        FOR I IN
        (
                SELECT
                        ORDERID,
                        SAP_CUST_NUMBER
                FROM
                        DBXNET.IGAK_POP_B)
        LOOP
                UPDATE
                        DBXNET.IGAK_D
                SET
                        SAP_CUST_NUMBER = I.SAP_CUST_NUMBER
                WHERE
                        ORDERID = I.ORDERID;
        END LOOP;
END;
--------------------------------------------------------------------------------------------
BEGIN
        FOR I IN
        (
                SELECT
                        KTO_NR,
                        FA_NR ,
                        ORDAT_SEQUENCE
                FROM
                        DBXNET.SAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.SAPCUST_KTO_MAP
                SET
                        FA_KTO_NR = I.FA_NR||' '||I.KTO_NR
                WHERE
                        ORDAT_SEQUENCE = I.ORDAT_SEQUENCE;
        END LOOP;
END;
------------------------------------------------------------------
DECLARE
        l_insert_stmt        VARCHAR2(4000);
        l_comma              VARCHAR2(1) DEFAULT ' ';
        l_src_table          VARCHAR2(500) := 'TABLE1';
        l_src_table_owner    VARCHAR2(500) := 'DB1';
        l_target_table       VARCHAR2(500) := 'TABLE2';
        l_target_table_owner VARCHAR2(500) := 'DB2';
BEGIN
        l_insert_stmt := 'INSERT INTO ' || l_target_table || ' ( ';
        FOR rec IN
        (
                SELECT
                        column_name
                FROM
                        all_tab_columns
                WHERE
                        TABLE_name = l_target_table
                AND     owner      = l_target_table_owner)
        LOOP
                l_insert_stmt := l_insert_stmt || l_comma || rec.column_name;
                l_comma       := ',';
        END LOOP;
        l_insert_stmt := l_insert_stmt || ' ) ';
        l_insert_stmt := l_insert_stmt || ' SELECT ';
        l_comma       := ' ';
        FOR rec IN
        (
                SELECT
                        column_name
                FROM
                        all_tab_columns
                WHERE
                        TABLE_name = l_src_table
                AND     owner      = l_src_table_owner)
        LOOP
                l_insert_stmt := l_insert_stmt || l_comma || rec.column_name;
                l_comma       := ',';
        END LOOP;
        l_insert_stmt := l_insert_stmt || ' FROM ' || l_src_table;
        dbms_output.put_line(l_insert_stmt);
END;
--------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        KTO_NR,
                        FA_NR ,
                        ORDAT_SEQUENCE
                FROM
                        DBXNET.SAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.SAPCUST_KTO_MAP
                SET
                        FA_KTO_NR = I.FA_NR||' '||I.KTO_NR
                WHERE
                        ORDAT_SEQUENCE = I.ORDAT_SEQUENCE;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
END;
-------------------------------------------------------------------------
DROP TABLE DBXNET.MIG;
CREATE TABLE DBXNET.MIG AS
SELECT
        ORDERID,
        SUBSTR (FA_KTO_NR, 7 , 10) AS KTO_NR
FROM
        DBXNET.IGAK_D;
----CREATES A NUMBER KTO_NR FROM STRING FA_KTO_NR
ALTER TABLE DBXNET.MIG ADD SAP_CUST_NUMBER VARCHAR2(200);
-----------------------------------------------------------------------
SELECT COUNT(*) FROM DBXNET.MATERIALMASTER;

SELECT TABLE_OWNER,TABLE_NAME,INSERTS,UPDATES,DELETES,TIMESTAMP AS LAST_CHANGE
FROM  DBA_TAB_MODIFICATIONS
WHERE TO_CHAR(TIMESTAMP,'DD.MM.YYYY') = TO_CHAR(sysdate,'DD.MM.YYYY') 
and table_owner='DBXNET'
and table_name in ('MATERIALMASTER');
