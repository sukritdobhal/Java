ALTER TABLE DBXNET.DFFC_D MODIFY VERTRETER NUMBER(10,0) NULL; --TODO: NEED TO CHECK WITH DEVELOPER.
COMMIT;
-------------------------------------------------------------------
UPDATE  DBXNET.DFFC_D SET VERTRETER = NULL;
------------------------------------------------------------------
ALTER TABLE DBXNET.DFFC_D MODIFY  VERTRETER VARCHAR2(200);