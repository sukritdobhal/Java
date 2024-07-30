---------------------------------------******************IGAK**************-------------------------------
ALTER SESSION SET CURRENT_SCHEMA = DBXNET;

ALTER TABLE SAPCUST_KTO_MAP DROP COLUMN FA_KTO;

UPDATE SAPCUST_KTO_MAP SET FA_KTO_NR = NULL;

SELECT MAX(LENGTH(FA_NR)) FROM SAPCUST_KTO_MAP WHERE FA_NR NOT LIKE 'GUTB';

SELECT * FROM SAPCUST_KTO_MAP WHERE FA_NR NOT LIKE 'GUTB';

SELECT LENGTH(KTO_NR) FROM SAPCUST_KTO_MAP;

UPDATE SAPCUST_KTO_MAP SET FA_KTO_NR = FA_NR||' '||' '||KTO_NR WHERE FA_NR  LIKE 'GUTB';

UPDATE DBXNET.NEWSAPCUST_KTO_MAP SET FA_KTO_NR = TRIM(FOSS_SALES_ORG)||' '||' '||FOSS_CUSTOMER_NO WHERE TRIM(FOSS_SALES_ORG) = 'GUTB';

ALTER TABLE DBXNET.NEWSAPCUST_KTO_MAP ADD FA_KTO_NR VARCHAR2(100);

SELECT * FROM DBXNET.NEWSAPCUST_KTO_MAP WHERE TRIM(FOSS_SALES_ORG) = 'GUTB';

UPDATE DBXNET.NEWSAPCUST_KTO_MAP SET FA_KTO_NR = TRIM(FOSS_SALES_ORG)||' '||' '||' ' ||' '||FOSS_CUSTOMER_NO WHERE TRIM(FOSS_SALES_ORG) <> 'GUTB';

SELECT MAX(LENGTH(FA_KTO_NR)) FROM DBXNET.NEWSAPCUST_KTO_MAP WHERE TRIM(FOSS_SALES_ORG) <> 'GUTB';


DESCRIBE DBXNET.NEWSAPCUST_KTO_MAP;


SELECT * FROM SAPCUST_KTO_MAP WHERE FA_KTO_NR IN (SELECT FA_KTO_NR FROM IGAK_D);
--------------------------******SAP_CUST_NUMBER/SALES_ORG**-------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT SAP_CUST_NUMBER, SAP_SALES_ORG, FA_KTO_NR FROM DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.IGAK_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER, SALES_ORG = I.SAP_SALES_ORG
                        WHERE FA_KTO_NR = I.FA_KTO_NR;
       END LOOP;
END;
-----------------------------------------------------------------------------------------
---------------------------------------------BLOB----------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (SELECT
                    A.ATM_BLOB,
                    C.ORDERID
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
                    B.SA_FANR_KEY LIKE 'VGNR%')
        LOOP
                UPDATE
                        DBXNET.IGAK_D
                SET
                        CREDIT_BLOB = I.ATM_BLOB
                        WHERE ORDERID = I.ORDERID;
       END LOOP;
END;
-------------------------------------------------------------------------------------------------
UPDATE DBXNET.IGAK_D SET SAP_CREDIT_NUMBER = SUBSTR(FOSS_AUF_NR,5,11);


--------------------------------------------ULI_M-----------------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        KTO_NR,
                        SAP_CUST_NUMBER
                FROM
                        DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.ULI_M
                SET
                       SAP_CUST_NUMBER   = I.SAP_CUST_NUMBER,  SAP_VERT_NR ='0'
                WHERE
                        KTO_NR = I.KTO_NR  AND BER_GRP='H';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT)||' ROWS AFFECTED.');
END;

-------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        KTO_NR,
                        SAP_CUST_NUMBER,
                        SAP_SALES_ORG
                FROM
                        DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.ULI_M
                SET
                       SAP_CUST_NUMBER   = I.SAP_CUST_NUMBER, SALES_ORG = I.SAP_SALES_ORG
                WHERE
                        KTO_NR = I.KTO_NR;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT)||' ROWS AFFECTED.');
END;

------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT * FROM DBXNET.SAPVERT_MAP)
        LOOP
                UPDATE
                        DBXNET.ULI_M
                SET
                       SAP_VERT_NR  = I.SAP_VERT_NR, SALES_ORG = I.SALES_ORG, SAP_CUST_NUMBER = '0'
                        WHERE VERT_NR = I.VERT_NR AND BER_GRP = 'V';
       END LOOP;
END;
-----------------------------------------------UMPO-------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT * FROM DBXNET.SAPVERT_MAP)
        LOOP
                UPDATE
                        DBXNET.ULI_M
                SET
                       SAP_VERT_NR  = I.SAP_VERT_NR, SALES_ORG = I.SALES_ORG
                        WHERE VERT_NR = I.VERT_NR;
       END LOOP;
END;

--------------------------------------------------------------------------------------------------
DECLARE
    CURSOR c1 IS
    SELECT
        t1.fa_kto_nr,
        t1.teilenr,
        t1.rg_nr,
        t1.auf_nr,
        t1.stat_dat,
        t1.stat_menge,
        t1.fw_cd,
        t1.kl_kz,
        t1.veeh,
        t2.sap_cust_number
    FROM
             dbstmt.umpo_d t1
        JOIN dbxnet.sapcust_kto_map t2 ON t1.fa_kto_nr = t2.fa_kto_nr;

    umpo_rec     c1%rowtype;
    v_kto_nr     umpo_rec.fa_kto_nr%TYPE;
    v_teil       umpo_rec.teilenr%TYPE;
    v_rg_nr      umpo_rec.rg_nr%TYPE;
    v_auf_nr     umpo_rec.auf_nr%TYPE;
    v_stat_dat   umpo_rec.stat_dat%TYPE;
    v_stat_menge umpo_rec.stat_menge%TYPE;
    v_fw_cd      umpo_rec.fw_cd%TYPE;
    v_kl_kz      umpo_rec.kl_kz%TYPE;
    v_veeh       umpo_rec.veeh%TYPE;
    v_sap_cust   umpo_rec.sap_cust_number%TYPE;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.UMPO_D';
    OPEN c1;
    LOOP
        FETCH c1 INTO
            v_kto_nr,
            v_teil,
            v_rg_nr,
            v_auf_nr,
            v_stat_dat,
            v_stat_menge,
            v_fw_cd,
            v_kl_kz,
            v_veeh,
            v_sap_cust;

        EXIT WHEN c1%notfound;
        EXECUTE IMMEDIATE 'INSERT INTO DBXNET.UMPO_D (FA_KTO_NR ,
TEILENR   ,
RG_NR     ,
AUF_NR    ,
STAT_DAT  ,
STAT_MENGE,
FW_CD     ,
KL_KZ     ,
VEEH      ,
SAP_CUST_NUMBER) VALUES (:B1, :B2, :B3, :B4, :B5, :B6, :B7, :B8, :B9, :B10)'
            USING v_kto_nr, v_teil, v_rg_nr, v_auf_nr, v_stat_dat, v_stat_menge, v_fw_cd, v_kl_kz, v_veeh, v_sap_cust;

        COMMIT;
    END LOOP;

END;
----------------------------------------------AUPO TO CHECK------------------------------------------------------------

DECLARE
    CURSOR c1 IS
    SELECT
        t1.pos_nr_ges,
        t1.auf_nr,
        t1.sach_nr,
        t1.sach_bez_1,
        t1.status_kz,
        t1.ges_meng,
        t1.res_menge,
        t1.li_meng,
        t1.li_ter_tag,
        t1.netto_pr_fw
    FROM
             dbauft.aupo_d t1
        JOIN dbauft.auko_d          t2 ON t1.auf_nr = t2.auf_nr
        JOIN dbxnet.sapcust_kto_map t3 ON t2.kto_nr = t3.kto_nr;

    aupo_rec   c1%rowtype;
    v_pos_nr   aupo_rec.pos_nr_ges%TYPE;
    v_auf_nr   aupo_rec.auf_nr%TYPE;
    v_sach_nr  aupo_rec.sach_nr%TYPE;
    v_sach_bez aupo_rec.sach_bez_1%TYPE;
    v_status   aupo_rec.status_kz%TYPE;
    v_ges_meng aupo_rec.ges_meng%TYPE;
    v_res_meng aupo_rec.res_menge%TYPE;
    v_li_meng  aupo_rec.li_meng%TYPE;
    v_li_ter   aupo_rec.li_ter_tag%TYPE;
    v_netto    aupo_rec.netto_pr_fw%TYPE;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO
            v_pos_nr,
            v_auf_nr,
            v_sach_nr,
            v_sach_bez,
            v_status,
            v_ges_meng,
            v_res_meng,
            v_li_meng,
            v_li_ter,
            v_netto;

        EXIT WHEN c1%notfound;
        EXECUTE IMMEDIATE 'TRUNCATE TABLE DBXNET.AUPO_D';
        COMMIT;
        EXECUTE IMMEDIATE 'INSERT INTO DBXNET.AUPO_D
(POS_NR_GES, AUF_NR, SACH_NR, SACH_BEZ_1, STATUS_KZ, GES_MENG, RES_MENGE, LI_MENG, LI_TER_TAG, NETTO_PR_FW)
VALUES (:B1, :B2, :B3, :B4, :B5, :B6, :B7, :B8, :B9, :B10)'
            USING v_pos_nr, v_auf_nr, v_sach_nr, v_sach_bez, v_status, v_ges_meng, v_res_meng, v_li_meng, v_li_ter, v_netto;
                                 --COMMIT;
    END LOOP;

END;

---------------------------------------------------------IAK_D----------------------------------------
SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT * FROM DBXNET.SAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.IAK_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER, SALES_ORG = I.SALES_ORG
                        WHERE FA_KTO_NR = I.FA_KTO_NR;
       END LOOP;
END;
------------------------------------------------------------------------------------------------------------------

--AUKO-----

SELECT AUF_NR FROM DBAUFT.AUKO_D A WHERE  TRUNC(SYSDATE) - TO_DATE(A.AUF_DAT,'YYYYMMDD') <=1185;

CREATE TABLE DBXNET.AUKO_AUF (AUF_NR CHAR (12));
-----IMPORT DATA------------------------

  CREATE TABLE DBXNET.AUKO_MIG AS    ( SELECT
                        A.AUF_NR          ,
                        A.AU_NR           ,
                        A.AU_DAT          ,
                        A.STATUS_KZ       ,
                        A.FIRM_NR         ,
                        A.KTO_NR          ,
                        A.AUF_DAT         ,
                        A.SPR_SL          ,
                        S.SAP_CUST_NUMBER ,
                        I.ORDERID
                FROM
                        DBAUFT.AUKO_D A
                JOIN
                        DBXNET.SAPCUST_KTO_MAP S
                ON
                        A.KTO_NR = S.KTO_NR
                JOIN
                        DBXNET.IAK_D I
                ON
                        I.FA_KTO_NR = S.FA_KTO_NR
                WHERE
                      A.AUF_NR IN (SELECT  AUF_NR from DBXNET.AUKO_AUF));
---------------------------------------------------------------------------------------
ALTER TABLE DBXNET.AUKO_D DISABLE CONSTRAINT AUKO_PRIMARY CASCADE ;


SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'AUKO_D' AND OWNER = 'DBXNET';

SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'IAK_D' AND OWNER = 'DBXNET';

ALTER TABLE DBXNET.IAK_D ENABLE CONSTRAINT SYS_C00674462;
-----------------------------------------------------------------------------------
INSERT INTO DBXNET.AUKO_D
(AUF_NR, AU_NR, AU_DAT, STATUS_KZ, FIRM_NR, KTO_NR, AUF_DAT, SPR_SL, SAP_CUST_NUMBER, ORDERID)
SELECT AUF_NR, AU_NR, AU_DAT, STATUS_KZ, FIRM_NR, KTO_NR, AUF_DAT, SPR_SL, SAP_CUST_NUMBER, ORDERID FROM DBXNET.AUKO_MIG;

COMMIT;
-------------------------------------------------------------------------------------
----ENABLE CONSTRAINTS AGAIN---------------------------------------------------------

SELECT ORDERID FROM DBXNET.AUKO_D GROUP BY ORDERID HAVING COUNT(ORDERID) > 1 ORDER BY ORDERID DESC;

SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'AUKO_D' AND OWNER = 'DBXNET';

SELECT * FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'IAK_D' AND OWNER = 'DBXNET';

ALTER TABLE DBXNET.IAK_D ENABLE CONSTRAINT SYS_C00674462;
-----------------------------------------------------------------------------------------
INSERT INTO DBXNET.AUPO_D
(POS_NR_GES, AUF_NR, SACH_NR, SACH_BEZ_1, STATUS_KZ, GES_MENG, RES_MENGE, LI_MENG, LI_TER_TAG, NETTO_PR_FW)
SELECT POS_NR_GES, AUF_NR, SACH_NR, SACH_BEZ_1, STATUS_KZ, GES_MENG, RES_MENGE, LI_MENG, LI_TER_TAG, NETTO_PR_FW
FROM DBAUFT.AUPO_D WHERE AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUKO_AUF);
-----------------------------------------------------------------------------------------
INSERT INTO DBXNET.PAPO_D
(PACK_POS_NR, AUF_NR, POS_NR_GES, PACK_NR, STATUS_KZ, RG_NR, LI_MENG)
SELECT PACK_POS_NR, AUF_NR, POS_NR_GES, PACK_NR, STATUS_KZ, RG_NR, LI_MENG FROM DBAUFT.PAPO_D WHERE AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUKO_AUF);
------------------------------------------------------------------------------------------
  CREATE TABLE DBXNET.AUKO_FOSS AS  SELECT
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
-----------------------------------------------------------------------------------------------------------------
DESCRIBE DBXNET.AUKO_D;
ALTER TABLE DBXNET.AUKO_FOSS ADD (PO_NUMBER VARCHAR2(30), ORDERID NUMBER(10), SAP_ORDER_NUMBER VARCHAR2(100));;
UPDATE DBXNET.AUKO_FOSS SET SAP_ORDER_NUMBER = AUF_NR;
COMMIT;
SELECT COUNT(DISTINCT(AUF_NR)) FROM DBXNET.AUKO_FOSS; 
SELECT COUNT(*) FROM DBXNET.AUKO_FOSS;
---------------------------------------------------------------------------------------------------------------------
--following fields to be migrated from DBAUFT.PAPO_D
-- PACK_NR (deliveryNoteNo)
--PACK_POS_NR (deliveryNotePos)
--RG_NR (fossInvoiceNo)
--LI_MENG (qtyDelivered)
-- AUF_NR (Foss order number)
-- POS_NR_GES (foss order pos)
-----------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.AUPO_FOSS AS SELECT DISTINCT
        T1.AUF_NR       ,
        T1.SACH_NR      ,
        T1.SACH_BEZ_1   ,
        T1.GES_MENG     ,
        T1.RES_MENGE    ,
        T1.LI_TER_TAG   ,
        T1.NETTO_PR_FW  ,
        T2.PACK_POS_NR     ,
        T2.POS_NR_GES      ,
        T2.PACK_NR         ,
        T2.STATUS_KZ  ,
        T2.RG_NR           ,
        T2.LI_MENG
FROM DBAUFT.AUPO_D T1 JOIN DBAUFT.PAPO_D T2 ON T1.AUF_NR = T2.AUF_NR WHERE T1.AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUKO_FOSS);
----------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.AUPO_FOSS ADD (PAKET_IDENT VARCHAR2(256), 
	SPEDITION NUMBER(10,0), 
	INV_URL VARCHAR2(4000), 
	DN_URL VARCHAR2(4000), 
	POD_URL VARCHAR2(4000), 
	CARRIER_NAME VARCHAR2(256), 
	POS_NR VARCHAR2(100) DEFAULT 'SBD_PARTS' NOT NULL ENABLE, 
	AUPO_SEQ NUMBER(9,0), 
	SAP_ORDER_NUMBER VARCHAR2(100), 
	SHIPPING_COSTS NUMBER(10,2), 
	ORDERID NUMBER(10,0), 
	PO_NUMBER VARCHAR2(30));
---------------------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.AUPO_FOSS SET SAP_ORDER_NUMBER = AUF_NR;
---------------------------------------------------------------------------------
SELECT * FROM DBXNET.AUPO_FOSS;

SELECT * FROM DBXNET.AUPO_D;
ALTER TABLE DBXNET.AUPO_FOSS ADD (PAKET_IDENT VARCHAR2(256), 
	SPEDITION NUMBER(10,0), 
	INV_URL VARCHAR2(4000), 
	DN_URL VARCHAR2(4000), 
	POD_URL VARCHAR2(4000), 
	CARRIER_NAME VARCHAR2(256), 
	POS_NR VARCHAR2(100) DEFAULT 'SBD_PARTS' NOT NULL ENABLE, 
	AUPO_SEQ NUMBER(9,0), 
	SAP_ORDER_NUMBER VARCHAR2(100), 
	SHIPPING_COSTS NUMBER(10,2), 
	ORDERID NUMBER(10,0), 
	PO_NUMBER VARCHAR2(30));
    
    
    UPDATE DBXNET.AUPO_FOSS SET SAP_ORDER_NUMBER = AUF_NR;
    
    SELECT * FROM DBXNET.XNVA_D;
    
    SELECT * FROM DBXNET.AUKO_FOSS;
	SELECT * FROM DBXNET.AUPO_FOSS;
	SELECT * FROM DBXNET.PAPO_D;
	SELECT * FROM DBXNET.ATM_D;
	SELECT * FROM DBXNET.ATMB_D;
    
    SELECT * FROM DBXNET.XNVA_D;
    
    DESCRIBE DBXNET.XNVA_D;
    
    ALTER TABLE DBXNET.XNVA_D DROP COLUMN PARTNER_NO;
    
    CREATE TABLE DBXNET.AUPO_FOSSS AS SELECT DISTINCT* FROM DBXNET.AUPO_FOSS;
    
    delete from dbxnet.aupo_fosss where li_ter_tag < 20210101;
    
    SELECT * FROM DBXNET.AUPO_FOSS;
    
    DROP TABLE DBXNET.AUPO_FOSS;
    
    ALTER TABLE DBXNET.AUPO_FOSSS RENAME TO AUPO_FOSS;
 -----------------------------------------------------------------------------------------
    CREATE TABLE DBXNET.AUKO_FOSSS AS SELECT DISTINCT* FROM DBXNET.AUKO_FOSS;
    
    delete from dbxnet.aupo_fosss where li_ter_tag < 20210101;
    
    SELECT * FROM DBXNET.AUPO_FOSS;
    
    DROP TABLE DBXNET.AUKO_FOSS;
    
    ALTER TABLE DBXNET.AUKO_FOSSS RENAME TO AUKO_FOSS;
	-----------------------------------------------------------------------------
	SELECT COUNT(DISTINCT(AUF_NR)) FROM DBXNET.AUKO_FOSS;
    SELECT COUNT(DISTINCT(AUF_NR)) FROM DBXNET.AUPO_FOSS;
    
     SELECT COUNT(DISTINCT(AUF_NR)) FROM DBAUFT.AUKO_D;
    SELECT COUNT(DISTINCT(AUF_NR)) FROM DBAUFT.AUPO_D;
    
    SELECT COUNT(AUF_NR) FROM DBXNET.AUKO_FOSS WHERE AUF_NR NOT IN (SELECT AUF_NR FROM DBXNET.AUPO_FOSS);
    
    DELETE FROM DBXNET.AUPO_FOSS WHERE AUF_NR NOT IN (SELECT AUF_NR FROM DBXNET.AUKO_FOSS);
    
    SELECT * FROM DBXNET.AUPO_FOSS;
-----------------------------------------------------------------------------------

ALTER TABLE DBXNET.AUKO_FOSS MODIFY AUF_NR VARCHAR2(100);

ALTER SESSION SET CURRENT_SCHEMA = DBXNET;

ALTER TABLE DBXNET.AUKO_D ADD IS_MIGRATED NUMBER(1) DEFAULT 0;

UPDATE AUKO_D SET IS_MIGRATED = 1 WHERE AUF_NR IN (SELECT AUF_NR FROM AUKO_FOSS);

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."AUPO_D_TRIGG" 
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


-- DBXNET.AUPO_D foreign keys

ALTER TABLE "DBXNET"."AUPO_D" ADD FOREIGN KEY ("SAP_ORDER_NUMBER")
	  REFERENCES "DBXNET"."AUKO_D" ("SAP_ORDER_NUMBER") DISABLE;
	 
------------------------------------------------ORDER MIGRATION FINAL------------------------------------------------------------
-----seeting up the orders migration finale------
----TABLES IN CONTEXT IAK, IAP, AUKO, AUPO, PAPO, PAKO---------------------------------------
---- dropping all previous staging tables:
DROP TABLE DBXNET.AUKO_FOSS;
DROP TABLE DBXNET.AUPO_FOSS;
-----CREATING THE header FOSS TABLE:
SELECT COUNT(*) FROM DBAUFT.AUKO_D;-- 1384974
SELECT * FROM DBAUFT.AUKO_D;
SELECT COUNT(DISTINCT(KTO_NR)) FROM DBAUFT.AUKO_D; -- 16559
--------------------------------------------------------------------------------------------
 CREATE TABLE DBXNET.AUKO_FOSS AS  SELECT
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
---------------------------------------------------------------------------------
SELECT COUNT(*) FROM DBXNET.AUKO_FOSS; -- 564917

SELECT * FROM DBAUFT.AUKO_D WHERE KTO_NR IN (SELECT KTO_NR FROM DBXNET.AUKO_FOSS); -- PICKING ONE KTO_NR = 35102878

SELECT COUNT(*) FROM DBAUFT.AUKO_D WHERE KTO_NR = 35102878 AND   AUF_DAT >= 20210101; -- 843
SELECT COUNT(*) FROM DBXNET.AUKO_FOSS WHERE KTO_NR = 35102878; --843
----------------------------------------------------------------------------------------------------------------------
DROP TABLE DBXNET.AUKO_FOSS;
----------------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.AUKO_FOSS AS  SELECT * FROM DBAUFT.AUKO_D;
ALTER TABLE DBXNET.AUKO_FOSS ADD IS_MIGRATED NUMBER(1) DEFAULT 0; 
UPDATE DBXNET.AUKO_FOSS SET IS_MIGRATED = 1;
COMMIT;
-----------------------------------------------------------------------------------------------------------
DROP TABLE DBXNET.PAPO_D;
DROP TABLE DBXNET.PAKO_D;
--------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.PAPO_D AS SELECT * FROM DBAUFT.PAPO_D;
CREATE TABLE DBXNET.PAKO_D AS SELECT * FROM DBAUFT.PAKO_D;

ALTER TABLE DBXNET.PAPO_D ADD IS_MIGRATED NUMBER(1);
ALTER TABLE DBXNET.PAKO_D ADD IS_MIGRATED NUMBER(1);

UPDATE DBXNET.PAPO_D SET IS_MIGRATED = 1;
UPDATE DBXNET.PAKO_D SET IS_MIGRATED = 1;
COMMIT;
------------------------------------IAK STARTS NOW----------------------------------------------------------------------------
-----appending the IAK Table---- from AUKO of DBAUFT/ AUKO_FOSS OF DBXNET.-----

ALTER TABLE DBXNET.IAK_D ADD IS_MIGRATED NUMBER(1) DEFAULT 0;
SELECT IS_MIGRATED FROM DBXNET.IAK_D;
SELECT MAX(ORDERID) FROM DBXNET.IAK_D; -- 779715
CREATE SEQUENCE DBXNET.ORDER_SEQ START WITH 779715 INCREMENT BY 1 MINVALUE 779715 NOMAXVALUE NOCYCLE CACHE 2;

CREATE OR REPLACE TRIGGER DBXNET.IAK_ORD
BEFORE INSERT ON DBXNET.IAK_D FOR EACH ROW 
BEGIN
  :new.ORDERID := ORDER_SEQ.NEXTVAL;
END;

DESCRIBE DBXNET.IAK_D;
-----------------------------------------------------------------INSERT-------------------------------------------------
INSERT INTO DBXNET.IAK_D
        (
                FA_KTO_NR      ,
                FW_CD          ,
                FOSS_AUF_NR    ,
                LI_TER_TAG,
                ZAHL_KOND_NR   ,
                VAL_DAT        ,
                NEBK_SL_TAB3_1 ,
                NEBK_SL_TAB3_2 ,
                NEBK_SL_TAB3_3 ,
                NEBK_PR_TAB3_1 ,
                NEBK_PR_TAB3_2 ,
                NEBK_PR_TAB3_3 ,
                NEBK_KZ_TAB3_1 ,
                NEBK_KZ_TAB3_2 ,
                NEBK_KZ_TAB3_3 ,
                LORT           ,
                KON_SL3        ,
                STATUS_KZ      ,
                LAST_MOD_DATE  ,
                LAST_MOD_TIME,
                IS_MIGRATED,
				FA_NR,
				AU_NR_KU,
				PROG_IDENT
        )
SELECT
       (FIRM_NR||' '||' '||KTO_NR)      ,
        FW_CD          ,
        AUF_NR    ,
        AU_DAT,
        ZAHL_KOND_NR   ,
        VAL_DAT        ,
        NEBK_SL_TAB3_1 ,
        NEBK_SL_TAB3_2 ,
        NEBK_SL_TAB3_3 ,
        NEBK_PR_TAB3_1 ,
        NEBK_PR_TAB3_2 ,
        NEBK_PR_TAB3_3 ,
        NEBK_KZ_TAB3_1 ,
        NEBK_KZ_TAB3_2 ,
        NEBK_KZ_TAB3_3 ,
        LORT           ,
        KON_SL10_3        ,
        STATUS_KZ      ,
        (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL),
        (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL),
        (SELECT 1 FROM DUAL),
		FIRM_NR,
		AU_NR,
		'FOSS' FROM DBAUFT.AUKO_D T2 WHERE FIRM_NR LIKE 'GUTB';
		





INSERT INTO DBXNET.IAK_D
        (
                FA_KTO_NR      ,
                FW_CD          ,
                FOSS_AUF_NR    ,
                LI_TER_TAG,
                ZAHL_KOND_NR   ,
                VAL_DAT        ,
                NEBK_SL_TAB3_1 ,
                NEBK_SL_TAB3_2 ,
                NEBK_SL_TAB3_3 ,
                NEBK_PR_TAB3_1 ,
                NEBK_PR_TAB3_2 ,
                NEBK_PR_TAB3_3 ,
                NEBK_KZ_TAB3_1 ,
                NEBK_KZ_TAB3_2 ,
                NEBK_KZ_TAB3_3 ,
                LORT           ,
                KON_SL3        ,
                STATUS_KZ      ,
                LAST_MOD_DATE  ,
                LAST_MOD_TIME,
                IS_MIGRATED,
				FA_NR,
				AU_NR_KU,
				PROG_IDENT
        )
SELECT
       (FIRM_NR||' '||' '||' '||' '||KTO_NR)      ,
        FW_CD          ,
        AUF_NR    ,
        AU_DAT,
        ZAHL_KOND_NR   ,
        VAL_DAT        ,
        NEBK_SL_TAB3_1 ,
        NEBK_SL_TAB3_2 ,
        NEBK_SL_TAB3_3 ,
        NEBK_PR_TAB3_1 ,
        NEBK_PR_TAB3_2 ,
        NEBK_PR_TAB3_3 ,
        NEBK_KZ_TAB3_1 ,
        NEBK_KZ_TAB3_2 ,
        NEBK_KZ_TAB3_3 ,
        LORT           ,
        KON_SL10_3        ,
        STATUS_KZ      ,
        (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL),
        (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL),
        (SELECT 1 FROM DUAL),
		FIRM_NR,
		AU_NR,
		'FOSS'
		FROM DBAUFT.AUKO_D T2 WHERE FIRM_NR NOT LIKE 'GUTB';
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBXNET.IAK_D
        (
                FA_KTO_NR      ,
                FW_CD          ,
                FOSS_AUF_NR    ,
                SAP_ORDER_NUMBER,
                LI_TER_TAG,
                ZAHL_KOND_NR   ,
                VAL_DAT        ,
                NEBK_SL_TAB3_1 ,
                NEBK_SL_TAB3_2 ,
                NEBK_SL_TAB3_3 ,
                NEBK_PR_TAB3_1 ,
                NEBK_PR_TAB3_2 ,
                NEBK_PR_TAB3_3 ,
                NEBK_KZ_TAB3_1 ,
                NEBK_KZ_TAB3_2 ,
                NEBK_KZ_TAB3_3 ,
                LORT           ,
                KON_SL3        ,
                STATUS_KZ      ,
                LAST_MOD_DATE  ,
                LAST_MOD_TIME,
                IS_MIGRATED,
				FA_NR,
				AU_NR_KU,
				PROG_IDENT
        )
SELECT
       (FIRM_NR||' '||' '||KTO_NR)      ,
        FW_CD          ,
        AUF_NR    ,
        AUF_NR,
        AU_DAT,
        ZAHL_KOND_NR   ,
        VAL_DAT        ,
        NEBK_SL_TAB3_1 ,
        NEBK_SL_TAB3_2 ,
        NEBK_SL_TAB3_3 ,
        NEBK_PR_TAB3_1 ,
        NEBK_PR_TAB3_2 ,
        NEBK_PR_TAB3_3 ,
        NEBK_KZ_TAB3_1 ,
        NEBK_KZ_TAB3_2 ,
        NEBK_KZ_TAB3_3 ,
        LORT           ,
        KON_SL10_3        ,
        STATUS_KZ      ,
         AUF_DAT,
           (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL)       ,
        (SELECT 1 FROM DUAL),
		FIRM_NR,
		AU_NR,
		'FOSS'
		FROM DBAUFT.AUKO_D T2 WHERE T2.FIRM_NR  LIKE 'GUTB' AND  T2.AUF_NR IN (
SELECT AUF_NR FROM DBAUFT.AUKO_D MINUS SELECT FOSS_AUF_NR FROM DBXNET.IAK_D);



--------------------------------------------------------------------------------------------------------------
COMMIT;
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO DBXNET.IAK_D
        (
                FA_KTO_NR      ,
                FW_CD          ,
                FOSS_AUF_NR    ,
                SAP_ORDER_NUMBER,
                LI_TER_TAG,
                ZAHL_KOND_NR   ,
                VAL_DAT        ,
                NEBK_SL_TAB3_1 ,
                NEBK_SL_TAB3_2 ,
                NEBK_SL_TAB3_3 ,
                NEBK_PR_TAB3_1 ,
                NEBK_PR_TAB3_2 ,
                NEBK_PR_TAB3_3 ,
                NEBK_KZ_TAB3_1 ,
                NEBK_KZ_TAB3_2 ,
                NEBK_KZ_TAB3_3 ,
                LORT           ,
                KON_SL3        ,
                STATUS_KZ      ,
                LAST_MOD_DATE  ,
                LAST_MOD_TIME,
                IS_MIGRATED,
				FA_NR,
				AU_NR_KU,
				PROG_IDENT
        )
SELECT
       (FIRM_NR||' '||' '||' '||' '||KTO_NR)      ,
        FW_CD          ,
        AUF_NR    ,
        AUF_NR,
        AU_DAT,
        ZAHL_KOND_NR   ,
        VAL_DAT        ,
        NEBK_SL_TAB3_1 ,
        NEBK_SL_TAB3_2 ,
        NEBK_SL_TAB3_3 ,
        NEBK_PR_TAB3_1 ,
        NEBK_PR_TAB3_2 ,
        NEBK_PR_TAB3_3 ,
        NEBK_KZ_TAB3_1 ,
        NEBK_KZ_TAB3_2 ,
        NEBK_KZ_TAB3_3 ,
        LORT           ,
        KON_SL10_3        ,
        STATUS_KZ      ,
         AUF_DAT,
           (
                SELECT
                        TO_NUMBER(TO_CHAR(sysdate,'YYYYMMDD'))
                FROM
                        DUAL)       ,
        (SELECT 1 FROM DUAL),
		FIRM_NR,
		AU_NR,
		'FOSS'
		FROM DBAUFT.AUKO_D T2 WHERE T2.FIRM_NR NOT LIKE 'GUTB' AND  T2.AUF_NR IN (
SELECT AUF_NR FROM DBAUFT.AUKO_D MINUS SELECT FOSS_AUF_NR FROM DBXNET.IAK_D);

---------------------------------------------------------------------------------------------
SELECT * FROM DBXNET.IAK_D WHERE IS_MIGRATED =1;
--UPDATE DBXNET.IAK_D SET SAP_ORDER_NUMBER = FOSS_AUF_NR  WHERE IS_MIGRATED =1; -- UNIQUE ON SAP ORDER NUMBER----

--------------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN
        (
                SELECT * FROM DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.IAK_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER, SALES_ORG = I.SAP_SALES_ORG
                        WHERE FA_KTO_NR = I.FA_KTO_NR AND IS_MIGRATED = 1;
       END LOOP;
END;

COMMIT;
------------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN
        (
                SELECT * FROM DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.IAK_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER, SALES_ORG = I.SAP_SALES_ORG
                        WHERE FA_KTO_NR = I.FA_KTO_NR AND IS_MIGRATED = 0;
       END LOOP;
END;
-----------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.IAK_D SET SAP_ORDER_NUMBER = FOSS_AUF_NR WHERE IS_MIGRATED = 0 AND SAP_ORDER_NUMBER IS NULL;
--------------------------------------------VALIDATIONS OF IAK--------------------------------------------------

ALTER TABLE DBXNET.IAK_D DROP CONSTRAINT UNI_SAP_ORDER;

UPDATE DBXNET.IAK_D SET SAP_ORDER_NUMBER = FOSS_AUF_NR WHERE IS_MIGRATED = 1 AND SAP_ORDER_NUMBER IS NULL;

SELECT I.FOSS_AUF_NR  AS IAK_FOSS,  A.AUF_NR AS AUK_FOSS, I.LAST_MOD_DATE AS IAK_MOD, A.AUF_DAT AS AUKO_DAT 
FROM DBXNET.IAK_D I JOIN  DBXNET.AUKO_D A ON I.FOSS_AUF_NR = A.AUF_NR;

SELECT I.FOSS_AUF_NR  AS IAK_FOSS,  A.AUF_NR AS AUK_FOSS, I.LAST_MOD_DATE AS IAK_MOD, A.AUF_DAT AS AUKO_DAT 
FROM DBXNET.IAK_D I JOIN  DBAUFT.AUKO_D A ON I.FOSS_AUF_NR = A.AUF_NR WHERE I.LAST_MOD_DATE <> A.AUF_DAT  AND I.IS_MIGRATED = 1;
------------------------------------------------------------------------------------------------
SELECT SAP_ORDER_NUMBER, ORDERID, IS_MIGRATED
FROM DBXNET.IAK_D
GROUP BY SAP_ORDER_NUMBER, ORDERID, IS_MIGRATED
HAVING COUNT(SAP_ORDER_NUMBER) > 1; 

SELECT * FROM  DBAUFT.AUKO_D T2 WHERE T2.FIRM_NR  LIKE 'GUTB' AND T2.AUF_NR NOT IN (SELECT FOSS_AUF_NR FROM DBXNET.IAK_D);

SELECT COUNT(*) FROM DBXNET.IAK_D WHERE SAP_CUST_NUMBER IS  NULL AND FA_KTO_NR IN (SELECT FA_KTO_NR FROM DBXNET.NEWSAPCUST_KTO_MAP);
--AND IS_MIGRATED = 1;

SELECT COUNT(*) FROM DBXNET.IAK_D WHERE SAP_ORDER_NUMBER IS NULL AND FOSS_AUF_NR IS NOT NULL;

SELECT COUNT(DISTINCT(SAP_ORDER_NUMBER)) FROM DBXNET.IAK_D; -- 1385728
SELECT COUNT(*) FROM DBXNET.IAK_D; -- 1385964 ---- 1385964 - 1385728 = 236
--DUPLICATE SAP_ORDER_NUMBER----
SELECT SAP_ORDER_NUMBER, COUNT(SAP_ORDER_NUMBER)
FROM DBXNET.IAK_D
GROUP BY SAP_ORDER_NUMBER
HAVING COUNT(SAP_ORDER_NUMBER) > 1; 

SELECT COUNT(*) FROM DBXNET.IAK_D WHERE SAP_ORDER_NUMBER IS NULL; --236
SELECT COUNT(DISTINCT(FA_KTO_NR)) FROM IAK_D WHERE SAP_CUST_NUMBER IS NOT NULL; -- 7256
SELECT COUNT(DISTINCT(SAP_CUST_NUMBER)) FROM IAK_D WHERE FA_KTO_NR IS NOT NULL; 
-------------------------------------AUPO STARTS NOW------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.AUKO_BCK AS SELECT * FROM DBXNET.AUKO_D WHERE AUF_NR IS NULL;
-----------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.AUKO_D AS 
SELECT AUF_NR, AU_NR, AU_DAT, STATUS_KZ, FIRM_NR, KTO_NR, AUF_DAT, SPR_SL FROM DBAUFT.AUKO_D;
------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.AUKO_D ADD (
"SAP_CUST_NUMBER" VARCHAR2(100), 
	"SAP_ORDER_NUMBER" VARCHAR2(100), 
	"ORDERID" NUMBER(10,0), 
	"PO_NUMBER" VARCHAR2(30),
    "IS_MIGRATED" NUMBER(1,0) DEFAULT 0);
--------------------------------------------------------------------------------------------------------------
UPDATE  DBXNET.AUKO_D SET  IS_MIGRATED = 1;
COMMIT;
--------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.AUKO_D MODIFY AUF_NR NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY AU_NR NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY AU_DAT NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY STATUS_KZ NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY KTO_NR NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY AUF_DAT NULL;
ALTER TABLE DBXNET.AUKO_D MODIFY SPR_SL NULL;
--------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN
        (
                SELECT FA_KTO_NR, SAP_CUST_NUMBER FROM DBXNET.IAK_D WHERE SAP_CUST_NUMBER IS NOT NULL)
        LOOP
                UPDATE
                        DBXNET.AUKO_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER
                        WHERE  FA_KTO_NR = I.FA_KTO_NR AND SAP_CUST_NUMBER IS NULL AND IS_MIGRATED = 1;
       END LOOP;
END;
----------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM DBXNET.AUKO_D WHERE SAP_CUST_NUMBER IS NOT NULL AND IS_MIGRATED = 1;

SELECT FA_KTO_NR, SAP_CUST_NUMBER FROM IAK_D WHERE SAP_CUST_NUMBER IS NOT NULL AND IS_MIGRATED = 1; --0001372399
SELECT * FROM AUKO_D WHERE SAP_CUST_NUMBER = '0001372399';

UPDATE AUKO_D SET SAP_ORDER_NUMBER = AUF_NR WHERE IS_MIGRATED = 1;
----------------------------------------------------------------------------------------------------------------------------

-----------------AUKO_D-------------------------
ALTER SESSION SET CURRENT_SCHEMA = DBXNET;

SELECT COUNT(*) FROM DBXNET.AUKO_D WHERE SAP_CUST_NUMBER IS NOT NULL AND IS_MIGRATED = 1;

SELECT ORDERID,FOSS_AUF_NR, FA_KTO_NR, SAP_CUST_NUMBER, SAP_ORDER_NUMBER, STATUS_KZ FROM IAK_D WHERE SAP_ORDER_NUMBER IS  NULL AND IS_MIGRATED = 0; --0001372399
SELECT * FROM AUKO_D WHERE SAP_CUST_NUMBER = '0001372399';

UPDATE AUKO_D SET SAP_ORDER_NUMBER = AUF_NR WHERE IS_MIGRATED = 1;

SELECT COUNT(*) FROM DBXNET.IAK_D WHERE SAP_CUST_NUMBER IS NULL; --236

ALTER TABLE DBXNET.AUKO_D ADD FA_KTO_NR VARCHAR2(100);
UPDATE AUKO_D SET FA_KTO_NR = FIRM_NR||' '||' '||KTO_NR WHERE FIRM_NR  LIKE 'GUTB';
UPDATE AUKO_D SET FA_KTO_NR = FIRM_NR||' '||' '||' '||' '||KTO_NR WHERE FIRM_NR NOT LIKE 'GUTB';

SELECT COUNT(DISTINCT(FA_KTO_NR)) FROM IAK_D WHERE SAP_CUST_NUMBER IS NOT NULL; -- 7256
SELECT COUNT(DISTINCT(SAP_CUST_NUMBER)) FROM IAK_D WHERE FA_KTO_NR IS NOT NULL; -- 7256
--------------------------------------------------------------------------------------------------
CREATE INDEX AUKO_FA_KTO ON AUKO_D(FA_KTO_NR);
CREATE INDEX NSAPCUST_KTO ON NEWSAPCUST_KTO_MAP(FA_KTO_NR);
CREATE INDEX AUKO_SAP_CUST ON AUKO_D(SAP_CUST_NUMBER);
CREATE INDEX SAPCUST ON NEWSAPCUST_KTO_MAP(SAP_CUST_NUMBER);
CREATE INDEX IAKCUST ON IAK_D(SAP_CUST_NUMBER);
CREATE INDEX IAKKTO ON IAK_D(FA_KTO_NR);
CREATE INDEX IAKAUFF ON DBXNET.IAK_D(FOSS_AUF_NR);
CREATE INDEX AUKO_AUF ON DBXNET.AUKO_D(AUF_NR);
CREATE INDEX AUKO_ORD ON DBXNET.AUKO_D(ORDERID);
CREATE INDEX IGAK_FA ON DBXNET.igak_d(FA_KTO_NR);
CREATE INDEX IGAK_AUF ON DBXNET.igak_d(SUBSTR(FOSS_AUF_NR,5,11));
CREATE INDEX IGAK_CREDIT ON DBXNET.igak_d(SAP_CREDIT_NUMBER);
CREATE INDEX ROIF_FA ON DBXNET.ROIF_D(FA_KTO_NR);
CREATE INDEX AUKO_FIRM ON DBXNET.AUKO_D(FIRM_NR);
CREATE INDEX AUKO_LAST_MOD ON DBXNET.AUKO_D(AUF_DAT);
CREATE INDEX IAK_LAST_MOD ON DBXNET.IAK_D(LAST_MOD_DATE);
CREATE INDEX PART_NUMBER_MAT ON DBXNET.MATERIALMASTER_LP(PARTS_NUMBER);
CREATE INDEX PART_DESCRIPTION_MAT ON DBXNET.MATERIALMASTER_LP(PARTS_DESCRIPTION);
CREATE INDEX PART_DESCRIPTION_UMPO ON DBXNET.UMPO_D(PARTS_DESCRIPTION);
CREATE INDEX PART_NUMBER_UMPO ON DBXNET.UMPO_D(teilenr);
CREATE INDEX SAPCUST_NUMBER_UMSD ON DBXNET.UMSD_D(SAP_CUST_NUMBER);
CREATE INDEX FOSSCUST_NUMBER_UMSD ON DBXNET.UMSD_D(FA_KTO_NR);
CREATE INDEX FOSSBUS_NUMBER_UMSD ON DBXNET.UMSD_D(FA_GUBKTO);
CREATE INDEX UMZ_UMS ON DBSTMT.UMSD_D(SUBSTR (fa_gubkto, 7, 1));
CREATE INDEX UMZ_TNS ON DBSTMT.TNST_M(SUBSTR (pr_ident, 1, 2));

-------------------------------------------------------------------------------------------

update dbxnet.persad_d set sales_org='DE01' where sap_cust_number='30999900';

-------------------------------------------------------------------------------------------------------------------------------
DELETE FROM DBXNET.IAK_D WHERE FOSS_AUF_NR IN 
( SELECT FOSS_AUF_NR FROM DBXNET.IAK_D GROUP BY FOSS_AUF_NR HAVING COUNT(FOSS_AUF_NR) >=2) AND IS_MIGRATED = 1;
----------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.IAP_D DISABLE CONSTRAINT MTD_IAP_D_R01;
----------------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.IAK_D SET SAP_ORDER_NUMBER = FOSS_AUF_NR WHERE IS_MIGRATED = 1;
-------------------------------------------------------------------------------------------------------------------------------
------AUPO:

ALTER TABLE DBXNET.AUPO_D ADD CONSTRAINT AUPO_CHECK CHECK (IS_MIGRATED IN (0,1));

SELECT COUNT(*) FROM DBXNET.AUPO_D;  --5182473
SELECT COUNT(*) FROM DBAUFT.AUPO_D; --5182316


SELECT * FROM DBXNET.AUPO_D WHERE IS_MIGRATED = 1;

ALTER TABLE DBXNET.AUPO_D ADD CONSTRAINT AUPO_CHECK CHECK (IS_MIGRATED IN (0,1));


UPDATE DBXNET.AUPO_D SET IS_MIGRATED = 0  WHERE IS_MIGRATED = NULL;
--------------------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN
        (
                SELECT FOSS_AUF_NR, ORDERID FROM DBXNET.IAK_D WHERE FOSS_AUF_NR IN (SELECT DISTINCT(FOSS_AUF_NR) FROM DBXNET.IAK_D))
        LOOP
                UPDATE
                        DBXNET.AUPO_D
                SET
                        ORDERID = I.ORDERID
                        WHERE  AUF_NR = I.FOSS_AUF_NR AND IS_MIGRATED = 1;
       END LOOP;
END;
---------------------------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN
        (
                SELECT FOSS_AUF_NR, SAP_CUST_NUMBER FROM DBXNET.IAK_D WHERE FOSS_AUF_NR IN (SELECT DISTINCT(FOSS_AUF_NR) FROM DBXNET.IAK_D))
        LOOP
                UPDATE
                        DBXNET.AUKO_D
                SET
                        SAP_CUST_NUMBER = I.SAP_CUST_NUMBER
                        WHERE  AUF_NR = I.FOSS_AUF_NR AND IS_MIGRATED = 1;
       END LOOP;
END;

-------------------------------------------------------------------------------------------------------------------------------------

DECLARE
BEGIN
        FOR I IN
        (
                SELECT FOSS_AUF_NR, ORDERID FROM DBXNET.IAK_D WHERE FOSS_AUF_NR IN (SELECT DISTINCT(FOSS_AUF_NR) FROM DBXNET.IAK_D))
        LOOP
                UPDATE
                        DBXNET.AUKO_D
                SET
                        ORDERID = I.ORDERID
                        WHERE  AUF_NR = I.FOSS_AUF_NR AND IS_MIGRATED = 1;
       END LOOP;
END;



---------------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.AUKO_D SET SAP_ORDER_NUMBER = NULL WHERE SAP_CUST_NUMBER IS NULL;
COMMIT;

SELECT COUNT(*) FROM DBXNET.AUKO_D WHERE SAP_CUST_NUMBER IS NULL AND SAP_ORDER_NUMBER <> NULL; -- =0


--------------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.AUPO_D SET IS_MIGRATED = 1  WHERE AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUKO_D WHERE IS_MIGRATED = 1);
SELECT COUNT(*) FROM DBXNET.AUPO_D WHERE IS_MIGRATED = 1;

SELECT COUNT(*) FROM DBXNET.AUPO_D WHERE ORDERID IS NULL;

SELECT * FROM DBXNET.AUPO_D WHERE AUF_NR IN (SELECT AUF_NR FROM DBXNET.AUKO_D WHERE IS_MIGRATED = 1); --5182473
SELECT COUNT(*) FROM DBAUFT.AUPO_D; --5182316

ALTER SESSION SET CURRENT_SCHEMA = DBXNET;
SELECT * FROM DBXNET.AUPO_D WHERE IS_MIGRATED = 1 AND AUF_NR IN (SELECT FOSS_AUF_NR FROM DBXNET.IAK_D);

ALTER TABLE DBXNET.AUPO_D ADD CONSTRAINT AUPO_CHECK CHECK (IS_MIGRATED IN (0,1));
------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.ROIF_D ADD ISSERIALNUMFOUND NUMBER(1) DEFAULT 0 CONSTRAINT CHECKIS CHECK (ISSERIALNUMFOUND IN (0,1));

SELECT * FROM DBXNET.ROIF_D;
-----------------------------------------------------------------------------------------------------
DECLARE
BEGIN
        FOR I IN (SELECT SAP_CUST_NUMBER, FA_KTO_NR  FROM DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.UMSD_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER
                        WHERE FA_KTO_NR = I.FA_KTO_NR;
       END LOOP;
      -- COMMIT;
END;
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."ROIF_D_TRIGG_LF" 
BEFORE INSERT ON DBXNET.ROIF_D
FOR EACH ROW
BEGIN
SELECT ROIF_D_LF.NEXTVAL INTO :NEW.LFD_NR8
FROM DUAL;
END;


SELECT MAX(LFD_NR8) FROM DBXNET.ROIF_D; -- 779715
CREATE SEQUENCE DBXNET.ROIF_D_LF START WITH 4500 INCREMENT BY 1 MINVALUE 4500 NOMAXVALUE NOCYCLE CACHE 2;
-----------------------------------------------------------------------------------------------------------

ALTER TABLE DBXNET.ROIF_D DROP COLUMN ISSERIALNUMFOUND;


ALTER TABLE DBXNET.ROIF_D ADD ISSERIALNUMFOUND NUMBER(1) DEFAULT 0 CONSTRAINT CHECKIS CHECK (ISSERIALNUMFOUND IN (0,1));

UPDATE DBXNET.ROIF_D SET ISSERIALNUMFOUND = 0 WHERE ISSERIALNUMFOUND = NULL;


SELECT * FROM DBXNET.ROIF_D;
-------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.ROIF_D MODIFY FA_KTO_NR NULL;
-----------------------------------------------------------------------------------
ALTER TABLE DBXNET.ROIF_D DROP CONSTRAINT MTD_C01;
-------------------------------------------------------------------------------------
---------------------------------------------MV WORK----------------------------------------------------------
------------------------------UMPO ALTER DROPPED-----------------------------------------------------------------------
    ALTER TABLE DBXNET.UMPO_D ADD ORDER_TYPE VARCHAR2(2);
    ALTER TABLE DBXNET.UMPO_D ADD SALES_ORDER_NUMBER VARCHAR2(100);
    ALTER TABLE DBXNET.UMPO_D ADD SALES_ORG VARCHAR2(100);
    ALTER TABLE DBXNET.UMPO_D ADD PARTS_DESCRIPTION VARCHAR2(100);
	ALTER TABLE DBXNET.UMPO_D RENAME COLUMN SALES_ORDER_NUMBER TO SAP_ORDER_NUMBER;
 --------------------------------------------------------------------------------------------------------------  
    
    SELECT ORDER_TYPE, SALES_ORDER_NUMBER, SALES_ORG, PARTS_DESCRIPTION  FROM DBXNET.UMPO_D;
-----------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.UMPO_D SET SAP_CUST_NUMBER = ('000'||''||SAP_CUST_NUMBER);
-------------------------------------------------------------------------------------------------------------------
SELECT U.teilenr, U.PARTS_DESCRIPTION, M.PARTS_NUMBER, M.PARTS_DESCRIPTION
FROM DBXNET.UMPO_D U INNER JOIN DBXNET.MATERIALMASTER_LP M ON U.teilenr = M.PARTS_NUMBER;
--------------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.UMSD_D AS SELECT  FA_NR, KTO_NR, TEILENR, DATUM, TNRDUMMY, UMS_REF_NR, MENGE, MENGE_GS, GES_WERT_FW, KL_KZ, AUFART_KZ, VKWG, AUFTR_KANAL, ORDAT_SEQUENCE
FROM DBSTMT.UMSD_D;
------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBSTMT.UMSD_D ADD SAP_CUST_NUMBER VARCHAR2(200);
-----------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.UMSD_D ADD SAP_CUST_NUMBER VARCHAR2(200);
----------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.UMSD_D ADD FA_KTO_NR VARCHAR2(100);
----------------------------------------------------------------------------------------------------------------------------------
SELECT U.FA_KTO_NR, U.SAP_CUST_NUMBER, M.FA_KTO_NR, M.SAP_CUST_NUMBER
FROM DBXNET.UMSD_D U INNER JOIN DBXNET.NEWSAPCUST_KTO_MAP M ON U.FA_KTO_NR = M.FA_KTO_NR;
-------------------------------------------------------------------------------------------------------------------
UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||KTO_NR WHERE TRIM(FA_NR)  LIKE 'GUTB';
UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||' '||' '||KTO_NR WHERE TRIM(FA_NR) NOT LIKE 'GUTB';
----------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.UMSD_D AS SELECT FA_GUBKTO, FA_NR, KTO_NR, TEILENR, DATUM, TNRDUMMY, UMS_REF_NR, MENGE, MENGE_GS, GES_WERT_FW, KL_KZ, AUFART_KZ, VKWG, AUFTR_KANAL, ORDAT_SEQUENCE
FROM DBSTMT.UMSD_D;


ALTER TABLE DBXNET.UMSD_D ADD GBUB VARCHAR2(10);
ALTER TABLE DBXNET.UMSD_D ADD UMS_KZ VARCHAR2(10);
UPDATE  DBXNET.UMSD_D UMSD SET  GBUB = SUBSTR (umsd.fa_gubkto, 7, 2);
--------------------------------------------------------------UMSD_D NEW---------------------------------------------------------------
CREATE TABLE DBXNET.UMSD_D AS SELECT FA_GUBKTO, FA_NR, KTO_NR, TEILENR, DATUM, TNRDUMMY, UMS_REF_NR, MENGE, MENGE_GS, GES_WERT_FW, KL_KZ, VKWG, AUFTR_KANAL, ORDAT_SEQUENCE
FROM DBSTMT.UMSD_D;
--------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.UMSD_D ADD SAP_CUST_NUMBER VARCHAR2(200);
------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.UMSD_D ADD AUFART_KZ VARCHAR2(5);
------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.UMSD_D ADD FA_KTO_NR VARCHAR2(100);


UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||KTO_NR WHERE TRIM(FA_NR)  LIKE 'GUTB';
UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||' '||' '||KTO_NR WHERE TRIM(FA_NR) NOT LIKE 'GUTB';
--------------------------------------------------------------------------------------------------------------------------------------------
DECLARE--------------------will tale 20 min---------------------------
BEGIN
        FOR I IN
        (
                SELECT SAP_CUST_NUMBER, FA_KTO_NR  FROM DBXNET.NEWSAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.UMSD_D
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER
                        WHERE FA_KTO_NR = I.FA_KTO_NR;
       END LOOP;
      -- COMMIT;
END;
------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_auf IS
    SELECT
        umsd.fa_gubkto,
        substr(umsd.fa_gubkto, 7, 1) AS umz1,
        substr(tnst.pr_ident, 1, 2)  AS umz2
    FROM
        dbstmt.umsd_d umsd,
        dbstmt.tnst_m tnst
    WHERE
            tnst.teilenr = umsd.teilenr
        AND umsd.satzart = 'UM';

    v_auf c_auf%rowtype;
BEGIN
    dbms_output.put_line('**********************%ISOPEN Test***********************');
    IF c_auf%isopen THEN
        CLOSE c_auf;
    ELSE
        NULL;
    END IF;
    OPEN c_auf;
    LOOP
        FETCH c_auf INTO v_auf;
        EXIT WHEN c_auf%notfound;
        IF ( v_auf.umz1 = '5' ) THEN
            UPDATE dbxnet.umsd_d t
            SET
                t.aufart_kz = 'SP'
            WHERE
                t.fa_gubkto = v_auf.fa_gubkto;

        ELSIF ( v_auf.umz1 = 'K' ) THEN
            UPDATE dbxnet.umsd_d T
            SET
                T.aufart_kz = 'WC'
            WHERE
                t.fa_gubkto = v_auf.fa_gubkto;

        ELSIF ( v_auf.umz1 = '4' ) THEN
            UPDATE dbxnet.umsd_d T
            SET
                T.aufart_kz = 'FG'
            WHERE
                t.fa_gubkto = v_auf.fa_gubkto;

        ELSIF ( v_auf.umz2 >= '10' ) THEN
            IF ( v_auf.umz2 <= '80' ) THEN
                UPDATE dbxnet.umsd_d T
                SET
                    T.aufart_kz = 'FG'
                WHERE
                    t.fa_gubkto = v_auf.fa_gubkto;

            ELSE
                NULL;
            END IF;
        END IF;

    END LOOP;

    dbms_output.put_line('*******************%ROWCOUNT Test***********************');
    dbms_output.put_line('Total records in emp table - ' || c_auf%rowcount);
    CLOSE c_auf;
    dbms_output.put_line('******%NOTFOUND Test - Reached the end of cursor********');
END;

-----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.UMSD_D AS SELECT fa_nr,kto_nr,str, UMS_KZ, kl_kz, aufart_kz, VKWG, auftr_kanal, teilenr, datum, stat_menge, ges_wert_fw, ordat_sequence
FROM DBXNET.MV_UMS01_MTD;

CREATE INDEX SAPCUST_NUMBER_UMSD ON DBXNET.UMSD_D(SAP_CUST_NUMBER);

CREATE INDEX FOSSCUST_NUMBER_UMSD ON DBXNET.UMSD_D(FA_KTO_NR);


ALTER TABLE DBXNET.UMSD_D ADD FA_KTO_NR VARCHAR2(100);

ALTER TABLE DBXNET.UMSD_D ADD SAP_CUST_NUMBER VARCHAR2(200);

ALTER TABLE DBXNET.UMSD_D  RENAME COLUMN UMS_KZ TO AUFART_KZ;

ALTER TABLE DBXNET.UMSD_D DROP COLUMN AUFART_KZ;




UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||KTO_NR WHERE TRIM(FA_NR)  LIKE 'GUTB';
UPDATE DBXNET.UMSD_D SET FA_KTO_NR = TRIM(FA_NR)||' '||' '||' '||' '||KTO_NR WHERE TRIM(FA_NR) NOT LIKE 'GUTB';

SELECT * FROM DBXNET.UMSD_D;


SELECT * FROM DBXNET.UMSD_D;

ALTER TABLE DBXNET.UMSD_D RENAME COLUMN STAT_MENGE TO MENGE;

UPDATE DBXNET.UMSD_D SET MENGE = MENGE * 1000;
UPDATE DBXNET.UMSD_D SET MENGE = ges_wert_fw * 100;


UPDATE DBXNET.UMSD_D SET AUFART_KZ = 'SP' WHERE AUFART_KZ = 'ET';

UPDATE DBXNET.UMSD_D SET AUFART_KZ = 'FG' WHERE AUFART_KZ = 'FW';

UPDATE DBXNET.UMSD_D SET AUFART_KZ = 'FG' WHERE AUFART_KZ = 'RM';

UPDATE DBXNET.UMSD_D SET AUFART_KZ = 'WC' WHERE AUFART_KZ = 'KD';

DROP TABLE DBXNET.UMSD_D;
-------------------------------------------------------------------------------------------------------------------------------------------








