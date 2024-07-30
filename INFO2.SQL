HTTPS://STACKOVERFLOW.COM/QUESTIONS/2446764/UPDATE-STATEMENT-WITH-INNER-JOIN-ON-ORACLE
HTTPS://DOCS.ORACLE.COM/CD/E11882_01/APPDEV.112/E25519/COMPOSITES.HTM#LNPLS005
HTTPS://FORUMS.ORACLE.COM/ORDS/APEXDS/POST/HELP-WITH-ORA-06511-PL-SQL-CURSOR-ALREADY-OPEN-1739
HTTPS://STACKOVERFLOW.COM/QUESTIONS/11341166/STRANGE-ERROR-ORA-01001-INVALID-CURSOR-IN-PROCEDURE
https://stackoverflow.com/questions/561836/oracle-partition-by-keyword
https://forums.oracle.com/ords/apexds/post/need-to-delete-duplicate-entries-and-retain-an-original-one-1741
https://stackoverflow.com/questions/50038894/importing-data-from-excel-to-multiple-tables-in-oracle-db
https://oracle-base.com/articles/8i/function-based-indexes
https://stackoverflow.com/questions/36179997/oracle-distinct-on-one-column
https://stackoverflow.com/questions/28869410/oracle-stored-procedure-to-import-csv-file-into-target-table
https://stackoverflow.com/questions/56739653/cant-read-files-using-external-tables-or-write-files-using-utl-file-using-pl-sq
----------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE SAPCUST_KTO_MAP READ ONLY;
----------------------------------------------------------------------------------------------------------------------------------------------------
ordat/tadro@srlvlp-ora01:1521/FOSS
SQLPLUS ordat/tadro@srlvlp-ora01:1521/FOSSTEST

SELECT owner,
       original_name,
       operation,
       droptime,
       can_undrop
FROM   dba_recyclebin
WHERE  TO_DATE (droptime, 'YYYY-MM-DD:HH24:MI:SS') BETWEEN SYSDATE - 3
                                                       AND SYSDATE
                                                       AND ORIGINAL_NAME = 'XNVA_D';
													   
													   
flashback table DBXNET.IGTA_D to before drop;													   

---------------------------------------------------------------------------------------------------------------------
HTTPS://STACKOVERFLOW.COM/QUESTIONS/2722630/ORACLE-DROP-INDEX-IF-EXISTS
DROP INDEX MTD_SLBK_D_I01;
SELECT
        INDEX_NAME
FROM
        USER_INDEXES
WHERE
        TABLE_NAME = 'MYTABLE'
AND     INDEX_NAME ='MYINDEXNAME'
DECLARE INDEX_NOT_EXISTS EXCEPTION;
PRAGMA EXCEPTION_INIT (INDEX_NOT_EXISTS, -1418);
        BEGIN
                EXECUTE IMMEDIATE 'DROP INDEX FOO';
        EXCEPTION WHEN INDEX_NOT_EXISTS THEN NULL;
        END;
/-----------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE   TYPE ARRAY_T
IS
        TABLE OF VARCHAR2(100);
        L_NUMBERS ARRAY_T;
BEGIN
        SELECT DISTINCT
                (T2.SAP_CUST_NUMBER) BULK COLLECT
        INTO
                L_NUMBERS
        FROM
                DBXNET.IGAK_D T1
        JOIN
                DBXNET.SAPCUST_KTO_MAP T2
        ON
                CAST(T2.KTO_NR AS VARCHAR2 (200)) = SUBSTR (T1.FA_KTO_NR, 7, 10);
        FOR INDX IN L_NUMBERS.FIRST .. L_NUMBERS.LAST
        LOOP DBMS_OUTPUT.PUT_LINE (L_NUMBERS (INDX));
        END LOOP;
END;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        TABLE_OWNER,
        TABLE_NAME ,
        INSERTS    ,
        UPDATES    ,
        DELETES    ,
        TIMESTAMP AS LAST_CHANGE
FROM
        DBA_TAB_MODIFICATIONS
WHERE
        TO_CHAR(TIMESTAMP,'DD.MM.YYYY') = TO_CHAR(SYSDATE,'DD.MM.YYYY')
AND     TABLE_OWNER                     ='DBXNET'
AND     TABLE_NAME IN ('IGAK_D');
--------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        TRIM(SUBSTR(TRIM(SA_FANR_KEY), -11, 11)) AUF_NR
FROM
        DBSIII.ATM_D
WHERE
        SA_FANR_KEY LIKE 'VGNR%'
AND     SUBSTR(TRIM(SA_FANR_KEY), -11, 11) IN
        (
                SELECT
                        TRIM(FOSS_AUF_NR)
                FROM
                        DBXNET.IGAK_D);
----------------------------------------------------------------------------------------------------------------------------------------
SELECT
        ATM_BLOB,
        ATM_EIND_KEY
FROM
        DBSIII.ATMB_D
WHERE
        ATM_EIND_KEY IN
        (
                SELECT
                        FILE_TEXT
                FROM
                        DBSIII.ATM_D
                WHERE
                        SA_FANR_KEY LIKE 'VGNR%'
                AND     SUBSTR(TRIM(SA_FANR_KEY), -11, 11) IN
                        (
                                SELECT
                                        TRIM(FOSS_AUF_NR)
                                FROM
                                        DBXNET.IGAK_D));
------------------------------------------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DBAUFT.BAKO_D;
DAPO_D --> DELIVERY NOTE PDF..
ORDER_OVERVIEW--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE TEST
        (
                ID   NUMBER,
                NAME VARCHAR2(20)
        )
;
SELECT
        *
FROM
        TEST;
DECLARE V_ID INTEGER;
V_NAME       VARCHAR2(50);
        BEGIN
                V_ID   := 1;
                V_NAME := 'SUNNY';
                EXECUTE IMMEDIATE 'INSERT INTO TEST (ID, NAME) VALUES(:B1, :B2)' USING V_ID, V_NAME;
                COMMIT;
        END;
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        S2.ITEM        ,
        S1.SHOP_ORDER  ,
        S1.OPERATION_NO,
        S1.START_DATE  ,
        S1.QTY_GOODS   ,
        S1.QTY_ENTERED ,
        S1.QTY_MRB
FROM
        (
                SELECT
                        SHOP_ORD_RPT.OPERATION_NO,
                        SHOP_ORD_RPT.SHOP_ORDER
                FROM
                        FLAME.SHOP_ORD_RPT
                WHERE
                        SHOP_ORD_RPT.OPERATION_NO = 110
                OR      SHOP_ORD_RPT.OPERATION_NO = 370) S1,
        (
                SELECT
                        SHOP_ORD.SHOP_ORDER
                FROM
                        FLAME.SHOP_ORD
                WHERE
                        SHOP_ORD.ITEM = '3A2375'
                OR      SHOP_ORD.ITEM = '3A2703') S2
WHERE
        S1.SHOP_ORDER = S2.SHOP_ORDER;
----------------------------------------------------------------------------------------------------------------------------------------------------
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
CREATE TABLE DBXNET.UGRI_D_B AS
SELECT
        *
FROM
        DBXNET.UGRI_D;
*****
CREATE TABLE PERSON
        (
                ID1  NUMBER PRIMARY KEY,
                NAME VARCHAR2(50)
        )
;
INSERT INTO
        PERSON
VALUES
        (
                6,
                'MIKE'
        )
;
CREATE TABLE ADDRESS
        (
                ID_ADDRESS     NUMBER PRIMARY KEY,
                ID1_FK         NUMBER            ,
                STREET_ADDRESS VARCHAR2(50)
        )
;
INSERT INTO
        ADDRESS
VALUES
        (
                1,6,
                '2ND AVENUE'
        )
;
INSERT INTO
        ADDRESS
VALUES
        (
                2,6,
                '4TH AVENUE'
        )
;
CREATE TABLE OWNEDCARS
        (
                ID_OWNEDCARS NUMBER PRIMARY KEY,
                ID1_FK       NUMBER            ,
                CAR_MODEL    VARCHAR2(50)
        )
;
INSERT INTO
        OWNEDCARS
VALUES
        (
                1,6,
                'BMW'
        )
;
INSERT INTO
        OWNEDCARS
VALUES
        (
                2,6,
                'MERCEDES'
        )
;
INSERT INTO
        OWNEDCARS
VALUES
        (
                3,6,
                'THIRD CAR'
        )
;
COMMIT;
SELECT
        P.NAME ,
        DECODE(ROW_NUMBER() OVER
                                 (
                                         PARTITION BY A.ROWN,
                                                 A.CNT
                                         ORDER BY C.ROWN
                                 )
                         ,
                        1,A.STREET_ADDRESS) STREET_ADDRESS ,
        C.CAR_MODEL
FROM
        PERSON P
LEFT JOIN
        (
                SELECT
                        ID1_FK         ,
                        STREET_ADDRESS ,
                        ROW_NUMBER() OVER
                                          (
                                                  PARTITION BY ID1_FK
                                                  ORDER BY ID_ADDRESS
                                          )
                        ROWN ,
                        COUNT(*) OVER
                                      (
                                              PARTITION BY ID1_FK
                                      )
                        CNT
                FROM
                        ADDRESS ) A
ON
        P.ID1=A.ID1_FK
LEFT JOIN
        (
                SELECT
                        ID1_FK    ,
                        CAR_MODEL ,
                        ROW_NUMBER() OVER
                                          (
                                                  PARTITION BY ID1_FK
                                                  ORDER BY ID_OWNEDCARS
                                          )
                        ROWN ,
                        COUNT(*) OVER
                                      (
                                              PARTITION BY ID1_FK
                                      )
                        CNT
                FROM
                        OWNEDCARS ) C
ON
        P.ID1=C.ID1_FK
AND
        CASE
        WHEN
                A.ROWN = C.ROWN
        THEN
                1
        WHEN
                C.ROWN > A.CNT
AND     A.CNT          = A.ROWN
        THEN
                1
        ELSE
                0
        END = 1
WHERE
        P.ID1='6'
ORDER BY
        P.NAME,
        A.ROWN,
        C.ROWN;
NAME STREET_ADDRESS CAR_MODEL ______________________________ ______________________________ ______________________________ MIKE 2ND AVENUE BMW MIKE 4TH AVENUE MERCEDES MIKE THIRD CAR 3 ROWS SELECTED.**************************************************************************************************************************************************----------------------------------------------------------------------------------------------------------------------------------------------------------
--DUPLICATE ROWS PARTITION
DELETE
FROM
        DBXNET.SLBK_D
WHERE
        ROWID IN
        (
                SELECT
                        ROWID
                FROM
                        (
                                SELECT
                                        ROW_NUMBER() OVER
                                                          (
                                                                  PARTITION BY BENUTZERX12,
                                                                          SAP_CUST_NUMBER ,
                                                                          TEILENR         ,
                                                                          UTNR
                                                                  ORDER BY BENUTZERX12    ,
                                                                          SAP_CUST_NUMBER ,
                                                                          TEILENR         ,
                                                                          UTNR
                                                          )
                                        NBLINES
                                FROM
                                        DBXNET.SLBK_D) T2
                WHERE
                        NBLINES > 1);
COMMIT;
CREATE UNIQUE INDEX "DBXNET"."MTD_SLBK_D_I03"
ON "DBXNET"."SLBK_D"
        (
                "BENUTZERX12"    ,
                "SAP_CUST_NUMBER",
                "TEILENR"        ,
                "UTNR"
        )
;
------------------------------------------------------------------------------------------------------------------------------------------------------------
--https://forums.oracle.com/ords/apexds/post/need-to-delete-duplicate-entries-and-retain-an-original-one-1741
CREATE TABLE DUPLICATE_TEST_TAB
        (
                ID       NUMBER      ,
                FLAG_ID  NUMBER      ,
                CRE_DT   DATE        ,
                CRE_USER VARCHAR2(50),
                CHG_DT   DATE        ,
                CHG_USER VARCHAR2(50)
        )
;
INSERT INTO
        DUPLICATE_TEST_TAB
VALUES
        (
                200,1        ,
                '20-SEP-2020',
                'JOHN'       ,
                '20-OCT-2020',
                'JOHN'
        )
;
INSERT INTO
        DUPLICATE_TEST_TAB
VALUES
        (
                200,1        ,
                '20-SEP-2020',
                'JOHN'       ,
                '20-OCT-2020',
                'JOHN'
        )
;
INSERT INTO
        DUPLICATE_TEST_TAB
VALUES
        (
                200,1        ,
                '20-SEP-2020',
                'JOHN'       ,
                '20-OCT-2020',
                'MIKE'
        )
;
INSERT INTO
        DUPLICATE_TEST_TAB
VALUES
        (
                200,1        ,
                '20-SEP-2020',
                'JOHN'       ,
                '18-OCT-2020',
                'DAVID'
        )
;
SELECT
        *
FROM
        DUPLICATE_TEST_TAB;
SELECT
        *
FROM
        DUPLICATE_TEST_TAB
WHERE
        ROWID IN
        (
                SELECT
                        MIN(ROWID)
                FROM
                        DUPLICATE_TEST_TAB T
                GROUP BY
                        ID      ,
                        FLAG_ID ,
                        CRE_USER,
                        CHG_DT);
DELETE
FROM
        DUPLICATE_TEST_TAB
WHERE
        ROWID NOT IN
        (
                SELECT
                        MIN(ROWID)
                FROM
                        DUPLICATE_TEST_TAB
                GROUP BY
                        ID      ,
                        FLAG_ID ,
                        CRE_USER,
                        CHG_DT );
----------------------------------------------------------------------------------------------------------------------------------------------------------------
DELETE
FROM
        DBXNET.GAZK_D
WHERE
        ROWID NOT IN
        (
                SELECT
                        MIN(ROWID)
                FROM
                        DBXNET.GAZK_D
                GROUP BY
                        TEILENR   ,
                        TNR_TYP   ,
                        MAX_BETRAG,
                        KENNZLX4  ,
                        LETZT_AEND,
                        USERX);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        GAZK_D
WHERE
        ROWID IN
        (
                SELECT
                        MIN(ROWID)
                FROM
                        DBXNET.GAZK_D
                GROUP BY
                        TEILENR   ,
                        TNR_TYP   ,
                        MAX_BETRAG,
                        KENNZLX4  ,
                        LETZT_AEND,
                        USERX)
ORDER BY
        TEILENR DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------DUPLICATE BASED ON MULTIPLE COLUMNS:
SELECT
        SAP_CUST_NUMBER ,
        DOC_NUMBER      ,
        TRX_TYPE
FROM
        DBXNET.CREDITRECEIVABLES_T T1
WHERE EXISTS
        (
                SELECT
                        1
                FROM
                        DBXNET.CREDITRECEIVABLES_T T2
                WHERE
                        T1.SAP_CUST_NUMBER = T2.SAP_CUST_NUMBER
                AND     T1.DOC_NUMBER      = T2.DOC_NUMBER
                AND     T1.TRX_TYPE        = T2.TRX_TYPE
                AND     T1.ROWID           <> T2.ROWID);
--------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO
        COLUMNS
FROM
        ONE TABLE TO ANOTHER:
--https://stackoverflow.com/questions/6027961/ora-00904-invalid-identifier
------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE
CURSOR C_XNVA IS
        SELECT
                T."Threshold_Limit",
                B.FA_NR            ,
                B.KON_SL           ,
                B.BER_GRP
        FROM
                DBXNET.XNVA_D_T T
        INNER JOIN
                DBXNET.XNVA_D B
        ON
                T.FA_NR     = B.FA_NR
        AND     T.VKBEREICH = B.VKBEREICH
        AND     T.KON_SL    = B.KON_SL
        AND     T.BER_GRP   = B.BER_GRP;
        C_REC C_XNVA%ROWTYPE;
                BEGIN
                        OPEN C_XNVA;
                        LOOP
                                FETCH   C_XNVA
                                INTO
                                        C_REC;
                                EXIT WHEN C_XNVA%NOTFOUND;
                                UPDATE
                                        DBXNET.XNVA_D D
                                SET
                                        D.Threshold_Limit = C_REC."Threshold_Limit"
                                WHERE
                                        D.BER_GRP = C_REC.BER_GRP
                                AND     D.FA_NR   = C_REC.FA_NR
                                AND     D.KON_SL  = C_REC.KON_SL;
                                COMMIT;
                        END LOOP;
                        CLOSE C_XNVA;
                END;
 ----------------------------       ---------------------------------------------------------------------------------------------------------------------------------------------------------
 
 https://andyspecht.github.io/2018-03-10-update-from-another-table-oracle/
 
 UPDATE tableA 
SET tableA.someColumn = (SELECT tableB.otherColumn
                         FROM tableB
                         WHERE tableA.joiningColumn = tableB.joiningColumn)
WHERE EXISTS
			(SELECT tableB.otherColumn
                         FROM tableB
                         WHERE tableA.joiningColumn = tableB.joiningColumn)
----------------------------------------------------------------------------
https://stackoverflow.com/questions/7030699/update-a-table-with-data-from-another-table

--CREATE BCK UP TABLE

BEGIN
FOR I IN (SELECT ID, NAME, DESC FROM TABLE1) 
LOOP
UPDATE TABLE2 SET NAME = I.NAME, DESC = I.DESC WHERE ID = I.ID;
END LOOP;
END;

********************************************************************
-------------------------------------------------------------------
-- CHANGE COL VERTRETER DBXNET.DFOR_D

-------------------------------------------------------------------
CREATE TABLE DBXNET.DFOR_D_BCK AS SELECT * FROM DBXNET.DFOR_D;
-------------------------------------------------------------------
UPDATE DBXNET.DFOR_D SET VERTRETER = NULL;
------------------------------------------------------------------
ALTER TABLE DBXNET.DFOR_D MODIFY  VERTRETER VARCHAR2(200);
------------------------------------------------------------------
BEGIN
FOR I IN (SELECT ORDAT_SEQUENCE, VERTRETER FROM DBXNET.DFOR_D_BCK) 
LOOP
UPDATE DBXNET.DFOR_D SET VERTRETER = I.VERTRETER WHERE ORDAT_SEQUENCE = I.ORDAT_SEQUENCE;
END LOOP;
END;
-----------------------------------------------------------------
COMMIT;
-----------------------------------------------------------------
DROP TABLE DBXNET.DFOR_D_BCK;
-----------------------------------------------------------------------
***********************************************************************

ALTER SESSION SET CURRENT_SCHEMA = DBXNET;

SELECT COUNT(*) FROM DBXNET.IAK_D WHERE SAP_CUST_NUMBER = '0001363117';

SELECT COUNT(*) FROM DBXNET.AUKO_FOSS WHERE SAP_CUST_NUMBER = '0001363117';

SELECT * FROM DBXNET.IAK_DV WHERE SAP_CUST_NUMBER = '0001363117';

CREATE TABLE DBXNET.IAK_D_BCK AS SELECT * FROM DBXNET.IAK_D;

SELECT COUNT(*) FROM DBXNET.AUKO_D WHERE SAP_CUST_NUMBER IS NOT   NULL;

SELECT COUNT(DISTINCT(FA_KTO_NR)) FROM DBXNET.NEWSAPCUST_KTO_MAP;

SELECT * FROM DBXNET.AUPO_FOSS WHERE AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUPO_FOSS GROUP BY AUF_NR 
HAVING COUNT(AUF_NR)>=2);

SELECT AUF_NR, SACH_NR, PACK_POS_NR, PACK_NR, RG_NR, LI_TER_TAG FROM DBXNET.AUPO_FOSS WHERE AUF_NR = '5HA11600536 ';


CREATE TABLE DBXNET.AUPO_META AS SELECT AUF_NR, SACH_NR, PACK_POS_NR, PACK_NR, RG_NR, LI_TER_TAG FROM DBXNET.AUPO_FOSS ;

UPDATE DBXNET.AUKO_D SET IS_MIGRATED = 1 WHERE AUF_NR  IN (SELECT AUF_NR FROM DBXNET.AUKO_FOSS);

UPDATE DBXNET.AUKO_D SET IS_MIGRATED = 0 WHERE SAP_CUST_NUMBER NOT  IN (SELECT SAP_CUST_NUMBER FROM DBXNET.AUKO_FOSS);

UPDATE DBXNET.AUKO_D SET IS_MIGRATED = 0 WHERE IS_MIGRATED = NULL;

SELECT COUNT(*) FROM AUPO_D WHERE IS_MIGRATED = 0;

UPDATE DBXNET.AUPO_D SET IS_MIGRATED = 1 WHERE AUF_NR  IN (SELECT AUF_NR FROM DBXNET.AUPO_FOSS);

UPDATE DBXNET.AUKO_D SET IS_MIGRATED = 0 WHERE SAP_CUST_NUMBER NOT  IN (SELECT SAP_CUST_NUMBER FROM DBXNET.AUKO_FOSS);

UPDATE DBXNET.AUPO_D SET IS_MIGRATED = 0 WHERE IS_MIGRATED = NULL;





SELECT * FROM DBXNET.AUPO_FOSS; 
--WHERE AUF_NR = '5HA11600536 ';

create index idx_1 on DBXNET.AUPO_D(AUF_NR);
create index idx_2 on DBXNET.AUPO_D(SAP_ORDER_NUMBER);
create index idx_3 on DBXNET.AUPO_D(RG_NR);
create index idx_4 on DBXNET.NEWSAPCUST_KTO_MAP(KTO_NR);
create index idx_5 on DBXNET.NEWSAPCUST_KTO_MAP(SAP_CUST_NUMBER);
create index idx_6 on DBXNET.AUKO_D(SAP_CUST_NUMBER);
create index idx_7 on DBXNET.AUKO_D(KTO_NR);
create index idx_8 on DBXNET.AUKO_FOSS(AUF_NR);
create index idx_9 on DBXNET.AUPO_FOSS(RG_NR);
create index idx_10 on DBXNET.AUPO_FOSS(AUF_NR);
create index idx_11 on DBXNET.AUPO_FOSS(SACH_NR);
create index idx_12 on DBXNET.AUPO_D(SACH_NR);
create index idx_13 on DBXNET.AUPO_FOSS(LI_TER_TAG);
create index idx_15 on DBXNET.AUPO_FOSS(PACK_POS_NR);
create index idx_16 on DBXNET.AUPO_FOSS(PACK_NR);
create index idx_17 on DBXNET.AUPO_FOSS(POS_NR_GES);



CREATE UNIQUE INDEX "DBXNET"."AUPO_META" ON "DBXNET"."AUPO_FOSS" ("AUF_NR", "SACH_NR", "PACK_POS_NR", "PACK_NR", "RG_NR", "LI_TER_TAG", "POS_NR_GES");


SELECT tablespace_name, file_name, bytes
FROM dba_temp_files WHERE tablespace_name like 'TEMP%';

DROP TABLE AUPO_META;

DROP INDEX  idx_13;

merge into AUPO_D t1
using (select AUF_NR,SACH_NR, RG_NR from AUPO_FOSS) t2
on (t1.AUF_NR = t2.AUF_NR AND t1.SACH_NR = t2.SACH_NR)
when matched then update
set t1.RG_NR = t2.RG_NR;

SELECT * FROM DBXNET.AUPO_META;
SELECT * FROM DBXNET.AUPO_FOSS;

SELECT count(*) 
FROM
        DBXNET.AUPO_FOSS
WHERE
        ROWID IN
        (
                SELECT
                        ROWID
                FROM
                        (
                                SELECT
                                        ROW_NUMBER() OVER
                                                          (
                                                                  PARTITION BY AUF_NR,
                                                                          SACH_NR,
                                                                          PACK_POS_NR,
                                                                          POS_NR_GES,
                                                                          LI_TER_TAG,
                                                                          NETTO_PR_FW,
                                                                          GES_MENG,
                                                                          LI_MENG
                                                                  ORDER BY AUF_NR,
                                                                          SACH_NR,
                                                                          PACK_POS_NR,
                                                                          POS_NR_GES,
                                                                          LI_TER_TAG,
                                                                          NETTO_PR_FW,
                                                                          GES_MENG,
                                                                          LI_MENG
                                                          )
                                        NBLINES
                                FROM
                                        DBXNET.AUPO_FOSS) T2
                WHERE
                        NBLINES > 1);

merge into AUKO_D t1
using (select KTO_NR, SAP_CUST_NUMBER from DBXNET.NEWSAPCUST_KTO_MAP) t2
on (t1.KTO_NR = t2.KTO_NR)
when matched then update
set t1.SAP_CUST_NUMBER = t2.SAP_CUST_NUMBER;

select 
   owner,
   tablespace_name, 
   segment_type, 
   segment_name 
from 
   dba_extents
where 
   file_id = 208
and 
   block_id = 1940106;
   
   
alter tablespace ORDAT shrink space keep 40m;



UPDATE DBXNET.AUPO_D SET SAP_ORDER_NUMBER = AUF_NR WHERE  SAP_ORDER_NUMBER IS NULL;

SELECT * FROM DBXNET.AUPO_FOSS WHERE AUF_NR = 'T3A11129897 ' AND SACH_NR = '73AFA009650 ' AND PACK_POS_NR = 'T3A13930708004';



SELECT O.OBJECT_NAME, S.SID, S.SERIAL#, P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT 
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS;

alter system kill session '1369,28224';

ALTER SYSTEM SET ddl_lock_timeout=20;

SELECT
                      DISTINCT T1.AUF_NR,
                       T1.AU_NR     ,
                       T1.AU_DAT    ,
                       T1.STATUS_KZ ,
                       T1.FIRM_NR   ,
                       T1.AUF_DAT   ,
                       T1.SPR_SL    ,
                       T2.KTO_NR    ,
                       T2.SAP_CUST_NUMBER
                FROM
                       DBAUFT.AUKO_D T1
                JOIN
                       DBXNET.NEWSAPCUST_KTO_MAP T2
                ON
                       T1.KTO_NR = T2.KTO_NR WHERE T1.AUF_DAT >= 20210101;

--------------------------------------------------------------------------------------------------------------
SELECT
    rg_nr,
    auf_nr
FROM
    dbauft.papo_d
WHERE
    rg_nr IN (
        SELECT DISTINCT
            ( rg_nr )
        FROM
            dbauft.papo_d
        WHERE
            rg_nr IN (
                SELECT DISTINCT
                    rg_nr
                FROM
                    dbauft.papo_d t1
                WHERE
                    EXISTS (
                        SELECT
                            1
                        FROM
                            dbauft.papo_d t2
                        WHERE
                                t2.rg_nr = t1.rg_nr
                            AND t2.auf_nr <> t1.auf_nr
                    )
            )
            AND rg_nr IS NOT NULL
            AND rg_nr <> ' '
    );
-----------------------------------------------------------------------------------------------------------------------	
SELECT *   
FROM
        DBXNET.XNVA_D
WHERE
        ROWID IN
        (
                SELECT
                        ROWID
                FROM
                        (
                                SELECT
                                        ROW_NUMBER() OVER
                                                          (
                                                                  PARTITION BY FA_NR,
                                                                          VKBEREICH ,
                                                                          KON_SL,
                                                                          BER_GRP,
                                                                          PARTNER_NUMBER,
                                                                          CONDITION_TYPE
                                                                  ORDER BY FA_NR,
                                                                          VKBEREICH,
                                                                          KON_SL,
                                                                          BER_GRP,
                                                                          PARTNER_NUMBER,
                                                                          CONDITION_TYPE
                                                          )
                                        NBLINES
                                FROM
                                        DBXNET.XNVA_D) T2
                WHERE
                        NBLINES > 1);
-------------------------------------
CREATE TABLE DBSIGB.MLST_D_BCK AS SELECT * FROM DBSIGB.MLST_D;

UPDATE DBSIGB.MLST_D SET MAILADRESSE = 'Extranet@sbdinc.com' WHERE MAILADRESSE = 'Extranet@mtdproducts.com';
-----------------------------------------------------------------------------------------------------------------------------------
SELECT menu, resourcekey, i18n.resourcetext
  FROM dbxnet.act_d  act
       JOIN dbxnet.i18n_d i18n
           ON     i18n.resource_key = RPAD (act.resourcekey, 60)
              AND languageid = 'en'
WHERE menu IN (  SELECT link
                    FROM dbxnet.menu_d menu
                   WHERE link <> ' '
                GROUP BY link) order by i18n.resourcetext;
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT  a.tablespace_name,
    ROUND (((c.BYTES - NVL (b.BYTES, 0)) / c.BYTES) * 100,2) percentage_used,
    c.BYTES / 1024 / 1024 space_allocated,
    ROUND (c.BYTES / 1024 / 1024 - NVL (b.BYTES, 0) / 1024 / 1024,2) space_used,
    ROUND (NVL (b.BYTES, 0) / 1024 / 1024, 2) space_free, 
    c.DATAFILES
  FROM dba_tablespaces a,
       (    SELECT   tablespace_name, 
                  SUM (BYTES) BYTES
           FROM   dba_free_space
       GROUP BY   tablespace_name
       ) b,
      (    SELECT   COUNT (1) DATAFILES, 
                  SUM (BYTES) BYTES, 
                  tablespace_name
           FROM   dba_data_files
       GROUP BY   tablespace_name
    ) c
  WHERE b.tablespace_name(+) = a.tablespace_name 
    AND c.tablespace_name(+) = a.tablespace_name
ORDER BY NVL (((c.BYTES - NVL (b.BYTES, 0)) / c.BYTES), 0) DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT MAX(ORDAT_SEQUENCE) FROM DBXNET.KD01_D;

----697581

CREATE SEQUENCE DBXNET.KD01_D_SEQN INCREMENT BY 1 MINVALUE 697900 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
---------------------------------------------------------------------
CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."KD01_DN_TRIGG" 
BEFORE INSERT ON DBXNET.KD01_D
FOR EACH ROW
BEGIN
        SELECT
                KD01_D_SEQN.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."KD01_DN_TRIGG" ENABLE;

COMMIT;
------------------------------------------------------------------------------------------------------------------------------------------------ZONESELECT * FROM DBXNET.roif_D WHERE LENGTH(SAP_CUST_NUMBER) = 10;
--AND TRIM(BENUTZER) = 'Weblager';

UPDATE  DBXNET.DFZG_D
   SET SAP_CUST_NUMBER = regexp_replace(SAP_CUST_NUMBER, '000000', '000') WHERE LENGTH(SAP_CUST_NUMBER) = 13;
   
  -------------------------------------------------------------------------------------------------------------------------------------
  invoice pdf:
  SELECT
                a.atm_blob,
                c.rg_nr
            FROM
                     dbsiii.atmb_d a
                JOIN dbsiii.atm_d  b ON a.atm_eind_key = b.file_text
                JOIN dbxnet.papo_d c ON TRIM(c.rg_nr) = substr(TRIM(b.sa_fanr_key),
                                                                     - 11,
                                                                     11)
            WHERE
               -- b.sa_fanr_key LIKE 'VGNR%'
                c.auf_nr in (SELECT FOSS_AUF_NR  FROM DBXNET.IAK_D WHERE SAP_CUST_NUMBER = '0001328490');
------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------my orders-----------------------------------------
SELECT
    a.atm_blob,
    c.rg_nr,
    c.auf_nr,
    c.pack_nr,
    d.orderid,
    d.last_mod_date
FROM
         dbsiii.atmb_d a
    JOIN dbsiii.atm_d  b ON a.atm_eind_key = b.file_text
    JOIN dbxnet.papo_d c ON TRIM(c.rg_nr) = substr(TRIM(b.sa_fanr_key),
                                                   - 11,
                                                   11)
    JOIN dbxnet.iak_d  d ON c.auf_nr = d.foss_auf_nr
WHERE
        d.sap_cust_number = '0001328490'
    --AND TRIM(c.auf_nr) LIKE '%333281';
ORDER BY D . LAST_MOD_DATE DESC ;
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT TABLE_OWNER,TABLE_NAME,INSERTS,UPDATES,DELETES,TIMESTAMP AS LAST_CHANGE
FROM  DBA_TAB_MODIFICATIONS
WHERE TO_CHAR(TIMESTAMP,'DD.MM.YYYY') = TO_CHAR(sysdate,'DD.MM.YYYY') 
and table_owner='DBXNET'
and table_name in ('PERSAD_D');
-----------------------------------------------------------------------------------------------------------------------------------------------
------how many sp, fg
SELECT
   COUNT(*)
FROM
   dbxnet.iak_d
WHERE
   last_mod_date IN ( '20240514', '20240515' )
   AND sap_order_number IN (
      SELECT
         sap_order_number
      FROM
         dbxnet.aupo_d
      WHERE
         sach_nr IN (
            SELECT
               parts_number
            FROM
               dbxnet.materialmaster
            WHERE
               matrial_type IN ( 'SP' )
         )
   )
   AND is_migrated = 0
   AND prog_ident = 'Portal';
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
   COUNT(*)
FROM
   dbxnet.IGAK_D
WHERE
   last_mod_date >  20240514
   --AND is_migrated = 0
   AND prog_ident IS NOT NULL
   AND SAP_CUST_NUMBER IS NOT NULL;

------------------------------------------------------------------------------
CREATE SEQUENCE DBXNET.ROIF_D_LF INCREMENT BY 1 MINVALUE 4500 MAXVALUE 9999999999999999999999999999 NOCYCLE CACHE 2 NOORDER ;
----------------------------------------------------------------------------------------------------------------------------------------------
  CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."ROIF_D_TRIGG_LF" 
BEFORE INSERT ON DBXNET.ROIF_D
FOR EACH ROW
BEGIN
SELECT ROIF_D_LF.NEXTVAL INTO :NEW.LFD_NR8
FROM DUAL;
END;
/
ALTER TRIGGER "DBXNET"."ROIF_D_TRIGG_LF" ENABLE;
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT A.CONDITION_TYPE, A.PARTNER_NUMBER, B.CONDITION_TYPE, B.PARTNER_NUMBER FROM DBXNET.XNVA_D A INNER JOIN DBXNET.xnva_d_bckp3 B
ON A.fa_nr = B.fa_nr AND A.vkbereich = B.vkbereich AND A.kon_sl = B.kon_sl AND A.ber_grp = B.ber_grp AND A.reihenfolge = B.reihenfolge;
----------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON

DECLARE
   v VARCHAR2(20) := NULL;
   t VARCHAR2(20) := NULL;
BEGIN
   FOR i IN (
      SELECT
         fa_nr,
         vkbereich,
         kon_sl,
         ber_grp,
         partner_number,
         condition_type,
         kennzlx8,
         reihenfolge
      FROM
         dbxnet.xnva_d_bckp3
   ) LOOP
--      SELECT
--         partner_number,
--         condition_type
--      INTO
--         v,
--         t
--      FROM
--         dbxnet.xnva_d
--      WHERE
--            fa_nr = i.fa_nr
--         AND vkbereich = i.vkbereich
--         AND kon_sl = i.kon_sl
--         AND ber_grp = i.ber_grp
--         AND reihenfolge = i.reihenfolge;
--
--      dbms_output.put_line('BEFORE UPDATE'
--                           || ' '
--                           || v
--                           || ' '
--                           || t);

      UPDATE dbxnet.xnva_d
      SET
         condition_type = i.condition_type,
         partner_number = i.partner_number
      WHERE
            fa_nr = i.fa_nr
         AND vkbereich = i.vkbereich
         AND kon_sl = i.kon_sl
         AND ber_grp = i.ber_grp
         AND reihenfolge = i.reihenfolge;
--
--      SELECT
--         partner_number,
--         condition_type
--      INTO
--         v,
--         t
--      FROM
--         dbxnet.xnva_d
--      WHERE
--            fa_nr = i.fa_nr
--         AND vkbereich = i.vkbereich
--         AND kon_sl = i.kon_sl
--         AND ber_grp = i.ber_grp
--         AND reihenfolge = i.reihenfolge;
--
--      dbms_output.put_line('AFTER UPDATE'
--                           || ' '
--                           || v
--                           || ' '
--                           || t);

   END LOOP;
END;
---------------------------------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.UMSD_D SET ORDAT_SEQUENCE = NULL;
ALTER TABLE DBXNET.UMSD_D MODIFY ORDAT_SEQUENCE  NUMBER(19,0);
CREATE SEQUENCE DBXNET.SEQN INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;
UPDATE DBXNET.UMSD_D SET ORDAT_SEQUENCE = SEQN.NEXTVAL;


DESCRIBE DBXNET.UMSD_D;
-------------------------------------------------------------------------------------------------------------------------------------------------