-----------------ADDITIONS TO MASTER DDL REL1-------------------------------------------------------
--------------------------------------AUPO_D MAKING NULLABLE--------------------------------------------------
ALTER TABLE DBXNET.AUPO_D MODIFY "AUF_NR" VARCHAR2(100) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "SACH_NR" VARCHAR2(100) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "GES_MENG" NUMBER(11,0) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "POS_NR_GES" CHAR(18) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "RES_MENGE" NUMBER(11,0) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "STATUS_KZ" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "LI_TER_TAG" NUMBER(10,0) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "NETTO_PR_FW" NUMBER(15,0) NULL;
ALTER TABLE DBXNET.AUPO_D MODIFY "LI_MENG" NUMBER(11,0) NULL;
-----------------------------------INDEXES-------------------------------------------------
CREATE INDEX "DBXNET"."IDX_1" ON "DBXNET"."AUPO_D" ("AUF_NR");
CREATE INDEX "DBXNET"."IDX_12" ON "DBXNET"."AUPO_D" ("SACH_NR");
CREATE INDEX "DBXNET"."IDX_2" ON "DBXNET"."AUPO_D" ("SAP_ORDER_NUMBER");
------------------------------------------------------------------------------------------
---------------------------------DBSI_M---------------------------------------------------
CREATE SEQUENCE DBXNET.DBSI_M_SEQ INCREMENT BY 1 MINVALUE 900 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBSI_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBSI_M"
FOR EACH ROW
BEGIN
        SELECT
                DBSI_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBSI_M_TRIGG" ENABLE;
---------------------------------------------------------------------------------------------------------------------------------
--DBVG11_KNN_M
CREATE SEQUENCE DBXNET.DBVG11_KNN_M_SEQ INCREMENT BY 1 MINVALUE 900 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVG11_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVG11_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVG11_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVG11_KNN_M_TRIGG" ENABLE;
---------------------------------------------------------------------------------------------------------------------------------
----DBVG12_KNN_M
CREATE SEQUENCE DBXNET.DBVG12_KNN_M_SEQ INCREMENT BY 1 MINVALUE 100 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVG12_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVG12_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVG12_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVG12_KNN_M_TRIGG" ENABLE;
-------------------------------------------------------------------------------------------------------------------------------------
--DBVGFE_KNN_M
CREATE SEQUENCE DBXNET.DBVGFE_KNN_M_SEQ INCREMENT BY 1 MINVALUE 900 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGFE_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGFE_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGFE_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGFE_KNN_M_TRIGG" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------
--DBVGFR_KNN_M
CREATE SEQUENCE DBXNET.DBVGFR_KNN_M_SEQ INCREMENT BY 1 MINVALUE 100 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGFR_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGFR_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGFR_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGFR_KNN_M_TRIGG" ENABLE;
--------------------------------------------------------------------------------------------------------------------------------------------
----DBVGHU_KNN_M
CREATE SEQUENCE DBXNET.DBVGHU_KNN_M_SEQ INCREMENT BY 1 MINVALUE 500 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGHU_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGHU_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGHU_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGHU_KNN_M_TRIGG" ENABLE;
----------------------------------------------------------------------------------------------------------------------------------------------
----DBVGMI_KNN_M
CREATE SEQUENCE DBXNET.DBVGMI_KNN_M_SEQ INCREMENT BY 1 MINVALUE 3500 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGHU_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGMI_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGMI_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGHU_KNN_M_TRIGG" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------------
------DBVGMS_KNN_M

CREATE SEQUENCE DBXNET.DBVGMS_KNN_M_SEQ INCREMENT BY 1 MINVALUE 350 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGMS_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGMS_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGMS_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGMS_KNN_M_TRIGG" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------------
----DBVGST_KNN_M

CREATE SEQUENCE DBXNET.DBVGST_KNN_M_SEQ INCREMENT BY 1 MINVALUE 5000 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGST_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGST_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGST_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGST_KNN_M_TRIGG" ENABLE;

ALTER TABLE DBXNET.DBVGST_KNN_M MODIFY "KON_TEXT_TAB_1" VARCHAR2(200);
------------------------------------------------------------------------------------------------------------------------------------------------
---DBVGWG_KNN_M
CREATE SEQUENCE DBXNET.DBVGWG_KNN_M_SEQ INCREMENT BY 1 MINVALUE 100 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."DBVGWG_KNN_M_TRIGG" 
BEFORE INSERT ON "DBXNET"."DBVGWG_KNN_M"
FOR EACH ROW
BEGIN
        SELECT
                DBVGWG_KNN_M_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."DBVGWG_KNN_M_TRIGG" ENABLE;
------------------------------------------------------------------------------------------------------------------------------------------------
"DBXNET"."DFPM_D"
-- ALTER TABLE "DBXNET"."DFPM_D" ADD SAP_CUST_NUMBER VARCHAR2(200);

-- CREATE OR REPLACE FORCE EDITIONABLE VIEW "DBXNET"."DFPM_DV" ("FA_NR", "BER_GRP", "VEEH", "KENNZLX50", "LIMPROZ_FCFB", "LIMPROZ_FCIS", "VERSION", "FB_STARTDAT", "FB_ENDEDAT", "PLAN_STARTDAT", "PLAN_ENDEDAT", "YEAR_ID", "ZKO_FB", "ZKO_MRZ", "VAL_TAGE_MRZ", "ZKO_APR", "VAL_TAGE_APR", "ZKO_MAI", "VAL_TAGE_MAI", "ZKO_JUN", "VAL_TAGE_JUN", "LETZT_AEND", "USERX", "ORDAT_SEQUENCE", "SAP_CUST_NUMBER") AS 
  -- SELECT
-- FA_NR,
-- BER_GRP,
-- VEEH,
-- KENNZLX50,
-- LIMPROZ_FCFB/100,
-- LIMPROZ_FCIS/100,
-- VERSION,
-- FB_STARTDAT,
-- FB_ENDEDAT,
-- PLAN_STARTDAT,
-- PLAN_ENDEDAT,
-- YEAR_ID,
-- ZKO_FB,
-- ZKO_MRZ,
-- VAL_TAGE_MRZ,
-- ZKO_APR,
-- VAL_TAGE_APR,
-- ZKO_MAI,
-- VAL_TAGE_MAI,
-- ZKO_JUN,
-- VAL_TAGE_JUN,
-- LETZT_AEND,
-- USERX,
-- ORDAT_SEQUENCE,
-- SAP_CUST_NUMBER
-- FROM DFPM_D;

-- GRANT SELECT ON "DBXNET"."DFPM_DV" TO "FOSS_SELECT";
------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "DBXNET"."DFZG_DV" ("FA_NR", "YEAR_ID", "VEEH", "KDGR", "SUPERGBUB", "KUNDE", "BRA_SL", "LISTUNG", "BER_GRP", "REIHENFOLGE", "LETZT_AEND", "USERX", "ORDAT_SEQUENCE", "SAP_CUST_NUMBER") AS 
  SELECT
FA_NR,
YEAR_ID,
VEEH,
KDGR,
SUPERGBUB,
KUNDE,
BRA_SL,
LISTUNG,
BER_GRP,
REIHENFOLGE,
LETZT_AEND,
USERX,
ORDAT_SEQUENCE,
SAP_CUST_NUMBER
FROM DFZG_D;
----------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE "DBXNET"."ERRORCODE" 
   -- (	"ERRORID" NUMBER(5,0), 
	-- "ENGLISH" VARCHAR2(200), 
	-- "GERMAN" VARCHAR2(200), 
	-- "ERROR CODE" NUMBER(*,0)
   -- ) SEGMENT CREATION IMMEDIATE 
  -- PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 -- NOCOMPRESS LOGGING
  -- STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  -- PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  -- BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  -- TABLESPACE "ORDAT_TABLESPACE" ;
--------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.IAK_D MODIFY "FA_NR" CHAR(6) DEFAULT ' ' NULL;
ALTER TABLE DBXNET.IAK_D MODIFY "FA_KTO_NR" CHAR(14) NULL;
ALTER TABLE DBXNET.IAK_D MODIFY "FOSS_AUF_NR" CHAR(12) NULL;
ALTER TABLE DBXNET.IAK_D MODIFY "AUFART_KZ" VARCHAR2(2);
ALTER TABLE DBXNET.IAK_D ADD "STATUS_ERP" NUMBER(9,0);

--------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.IGAK_D MODIFY "FA_KTO_NR" CHAR(14) NULL;
ALTER TABLE DBXNET.IGAK_D MODIFY "FOSS_AUF_NR" CHAR(12) NULL;
ALTER TABLE DBXNET.IGAK_D ADD CONSTRAINT "CKIAGDSER" CHECK (ISSERIALNUMFOUND IN (0,1)) ENABLE;
---------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
-- ALTER TABLE DBXNET.ROIF_D MODIFY "FA_KTO_NR" CHAR(14) NULL;
-- ALTER TABLE DBXNET.ROIF_D ADD CONSTRAINT "CKROIFSER" CHECK (ISSERIALNUMFOUND IN (0,1)) ENABLE;
------------------------------------------------------------------------------------------------------------------------------------
----SK3_D
CREATE SEQUENCE DBXNET.SK3_D_SEQ INCREMENT BY 1 MINVALUE 21000 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."SK3_D_TRIGG" 
BEFORE INSERT ON "DBXNET"."SK3_D"
FOR EACH ROW
BEGIN
        SELECT
                SK3_D_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."SK3_D_TRIGG" ENABLE;
--------------------------------------------------------------------------------------------------------------------------------------------------
--DBXNET"."SLBK_D
ALTER TABLE DBXNET.SLBK_D MODIFY "STATUS_KZ" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "KTO_NR" NUMBER(10,0) NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "LI_TER_TAG" NUMBER(10,0) DEFAULT 0 NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "TIMESTAMP_RESV" NUMBER(19,0) DEFAULT 0 NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "LI_TER_TAG_2" NUMBER(10,0) DEFAULT 0 NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "LORT" VARCHAR2(4) NULL;
ALTER TABLE DBXNET.SLBK_D MODIFY "GBUB" VARCHAR2(2) NULL;
----------------------------------------------------------------------------------------------------------------------------------------------------
----TTD_D
ALTER TABLE DBXNET.TTD_D MODIFY "IDENTNR" CHAR(6) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "SA_IDENTNR_VG" CHAR(46) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "SA_VG" CHAR(40) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "WERT_VON" NUMBER(15,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "WERT_BIS" NUMBER(15,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "ABW_PROZ" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "LETZT_AEND" NUMBER(10,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "SORT_FOLGE" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "MINUS_TOLERANZ" NUMBER(15,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "PLUS_TOLERANZ" NUMBER(10,0) NULL;
ALTER TABLE DBXNET.TTD_D MODIFY "SA_TEILENR" CHAR(14) NULL;


CREATE SEQUENCE DBXNET.TTD_D_SEQ INCREMENT BY 1 MINVALUE 21000 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE EDITIONABLE TRIGGER "DBXNET"."TTD_D_TRIGG" 
BEFORE INSERT ON "DBXNET"."TTD_D"
FOR EACH ROW
BEGIN
        SELECT
                TTD_D_SEQ.NEXTVAL
        INTO
                :NEW.ORDAT_SEQUENCE
        FROM
                DUAL;
END;

ALTER TRIGGER "DBXNET"."TTD_D_TRIGG" ENABLE;
-------------------------------------------------------------------------------------------------------------------------------------------------
--ULI_M
-----MIGHT THROW PAGINATION ERROR

-- ALTER TABLE DBXNET.ULI_M MODIFY "ENTRIES_ON_PAGE" NUMBER(5,0);
------------------------------------------------------------------------------------------------------------------------------------------------
----UMPO_D

ALTER TABLE DBXNET.UMPO_D MODIFY "FA_KTO_NR" CHAR(14) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "TEILENR" CHAR(12) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "RG_NR" CHAR(12) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "AUF_NR" CHAR(12) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "STAT_DAT" NUMBER(10,0) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "STAT_MENGE" NUMBER(11,0) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "GES_WERT_FW" NUMBER(19,0) NULL;
ALTER TABLE DBXNET.UMPO_D MODIFY "GES_WERT_EUR" NUMBER(11,0) NULL;
--------------------------------------------------------------------------------------------------------------------------------------------
------XNVA_D-----------------------------------------------------
ALTER TABLE DBXNET.XNVA_D MODIFY "FA_NR" CHAR(6) NULL;
ALTER TABLE DBXNET.XNVA_D MODIFY "KON_SL" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.XNVA_D MODIFY "REIHENFOLGE" NUMBER(5,0) NULL;
ALTER TABLE DBXNET.XNVA_D ADD "SHIPPING_CONDITION" VARCHAR2(10) NULL;

--------------------------------------------------------------------------------------------------------------------------------------------
---CHECK
ALTER TABLE DBXNET.IAP_D DROP CONSTRAINT MTD_IAP_D_R01;
-------------------------------------------------------------------------------------------------------------------------------------------
