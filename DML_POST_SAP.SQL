-------------------------------------------------------------------------------------------------------------------------------------------------------
 --  Subject    : DML POST SAP DATA PUSH

 --------------------------------------------------------------------------------------
 --  change history
 --  name:       date:        tag:            description:
 --  -----       -----        ----            ------------
 -- SUKRIT		04/17/24	-SD--              FIRST DRAFT.--- SAP WILL PUSH DATA INTO PERSAD KD01 CUST_BRAND

 -------------------------------------------------------------------
 
--<SD 02/20>-----
 ALTER SESSION SET CURRENT_SCHEMA = DBXNET;
 -------------------------------------------------------------------

-------------------------------------------------------------OLD PARTS TO NEW PARTS---------------------------------------------------------
--DBXNET.IGTS_D,
--DBXNET.IGTA_D,
--DBAUGB.TNFC_D

ALTER TABLE DBXNET.IGTS_D RENAME COLUMN TEILENR TO FOSS_TEILENR;

ALTER TABLE DBXNET.IGTS_D ADD  PARTS_NUMBER VARCHAR2(100);

SELECT * FROM DBXNET.IGTS_D WHERE FOSS_TEILENR IN (SELECT OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER);

 
DECLARE
BEGIN
FOR I IN (SELECT PARTS_NUMBER, OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER)
LOOP
UPDATE DBXNET.IGTS_D SET PARTS_NUMBER = I.PARTS_NUMBER WHERE FOSS_TEILENR = I.OLD_MATERIAL_NUMBER;
END LOOP;
END;

ALTER TABLE DBXNET.IGTS_D RENAME COLUMN PARTS_NUMBER TO TEILENR;

UPDATE DBXNET.IGTS_D SET TEILENR = FOSS_TEILENR WHERE TEILENR IS NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM DBXNET.IGTA_D WHERE TEILENR IN (SELECT OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER);

ALTER TABLE DBXNET.IGTA_D RENAME COLUMN TEILENR TO FOSS_TEILENR;

ALTER TABLE DBXNET.IGTA_D ADD  PARTS_NUMBER VARCHAR2(100);

DECLARE
BEGIN
FOR I IN (SELECT PARTS_NUMBER, OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER)
LOOP
UPDATE DBXNET.IGTA_D SET PARTS_NUMBER = I.PARTS_NUMBER WHERE FOSS_TEILENR = I.OLD_MATERIAL_NUMBER;
END LOOP;
END;

ALTER TABLE DBXNET.IGTA_D RENAME COLUMN PARTS_NUMBER TO TEILENR;

UPDATE DBXNET.IGTA_D SET TEILENR = FOSS_TEILENR WHERE TEILENR IS NULL
----------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE DBAUGB.TNFC_D ADD  PARTS_NUMBER VARCHAR2(100);

ALTER TABLE DBAUGB.TNFC_D RENAME COLUMN TEILENR TO FOSS_TEILENR;

--SELECT * FROM DBAUGB.TNFC_D WHERE FOSS_TEILENR IN (SELECT OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER);

DECLARE
BEGIN
FOR I IN (SELECT PARTS_NUMBER, OLD_MATERIAL_NUMBER FROM DBXNET.MATERIALMASTER)
LOOP
UPDATE DBAUGB.TNFC_D SET PARTS_NUMBER = I.PARTS_NUMBER WHERE FOSS_TEILENR = I.OLD_MATERIAL_NUMBER;
END LOOP;
END;

ALTER TABLE DBAUGB.TNFC_D RENAME COLUMN PARTS_NUMBER TO TEILENR;
UPDATE DBXNET.IGTA_D SET TEILENR = FOSS_TEILENR WHERE TEILENR IS NULL;
SELECT * FROM DBAUGB.TNFC_D WHERE TEILENR IS NOT NULL;
-------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------KDGR OF KD01---------------------------------------------------------------
DECLARE 
kd_kdgr number := 0;
BEGIN
FOR I IN (SELECT KDGR, SAP_CUST_NUMBER  FROM  DBXNET.NEWSAPCUST_KTO_MAP)
LOOP
UPDATE DBXNET.KD01_D SET KDGR = I.KDGR WHERE SAP_CUST_NUMBER = I.SAP_CUST_NUMBER;
kd_kdgr := kd_kdgr + SQL%rowcount;
END LOOP;
DBMS_OUTPUT.PUT_LINE ('Number of rows updated kd_kdgr'||' '|| kd_kdgr);
INSERT INTO DBXNET.AUDIT_LOG (OPERATION, OPS_DETAILS, AFFECTED_ROWS) VALUES('UPDATE', 'Number of rows updated kd_kdgr', kd_kdgr);
END;
-------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
 UPDATE DBXNET.PERSAD_D SET SALES_ORG ='DE01' WHERE SAP_CUST_NUMBER LIKE '%30999900';

----------------------------------------------------------------------------------------------------------------------------------------
 UPDATE DBXNET.KD01_D SET SAP_CUST_NUMBER = '30999900' where fa_kto_nr like '%GUTB  30999900';
----------------------------------------------------------------------------------------------------------------------------------