--------------------SOME CAT2 TABLES WILL BE HANDLED IN DATA MIG SCRIPTS---------------------------------------------------------------
ALTER SESSION SET CURRENT_SCHEMA = DBXNET;
------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE DBXNET.VERT_D AS SELECT * FROM DBAUFT.VERT_D;
----------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.VERT_D MODIFY ORDAT_SEQUENCE NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE;
----------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.VERT_D ADD SAP_CUST_NUMBER VARCHAR2(200);
-----------------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX FA_VERT ON DBXNET.VERT_D(FA_KTO_NR);
CREATE INDEX SAPCUST_VERTD ON DBXNET.VERT_D(SAP_CUST_NUMBER);
--------------------------------------------------------------------------------------------------------------------------------------------
DECLARE
BEGIN
FOR I IN (SELECT FA_KTO_NR, SAP_CUST_NUMBER FROM DBXNET.NEWSAPCUST_KTO_MAP)
LOOP
UPDATE DBXNET.VERT_D V SET V.SAP_CUST_NUMBER = I.SAP_CUST_NUMBER WHERE V.FA_KTO_NR = I.FA_KTO_NR;
END LOOP;
END;
-----------------------------------------------------------------------------------------------------------------------------------------------
-- DBXNET.VERT_DV source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "DBXNET"."VERT_DV" ("KTO_NR", "PROV_GRP", "MWST_KZ", "TEL_TAB6_1", "TEL_TAB6_2", "TEL_TAB6_3", "TEL_TAB6_4", "TEL_TAB6_5", "TEL_TAB6_6", "VERKN_KZ", "SPR_SL", "STAT_KZ", "LETZT_AEND", "USERX", "ABRECH_ZEIT", "FA_KTO_NR", "VERT_USER", "ORDAT_SEQUENCE", "SAP_CUST_NUMBER") AS 
  SELECT
KTO_NR,
PROV_GRP,
MWST_KZ,
TEL_TAB6_1,
TEL_TAB6_2,
TEL_TAB6_3,
TEL_TAB6_4,
TEL_TAB6_5,
TEL_TAB6_6,
VERKN_KZ,
SPR_SL,
STAT_KZ,
LETZT_AEND,
USERX,
ABRECH_ZEIT,
FA_KTO_NR,
VERT_USER,
ORDAT_SEQUENCE,
SAP_CUST_NUMBER
FROM VERT_D;
---------------------------------------------------------------------------------------------------------------------------------------------
