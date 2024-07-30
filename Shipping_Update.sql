
 --******************************************************NEW***************************************************************************************
 DROP TABLE "DBXNET"."SAP_SHIPPING_XNVA";
----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE "DBXNET"."SAP_SHIPPING_XNVA" 
   (
	"KON_SL" NUMBER(5,0), 
	"CONDITION_TYPE" VARCHAR2(200), 
	"PARTNER_NUMBER" NUMBER(9,2)
   );

-------------------------------------------------------LOAD DATA FROM CSV------------------------------------------------------------------------
UPDATE DBXNET.SAP_SHIPPING_XNVA SET KON_SL = TRIM(KON_SL), CONDITION_TYPE = TRIM(CONDITION_TYPE), PARTNER_NUMBER = TRIM(PARTNER_NUMBER);
-------------------------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM XNVA_D;
DECLARE
    ln_affected_rows NUMBER := 0;
	xnva_count_pre NUMBER:= 0;
	xnva_count_post NUMBER:= 0;
BEGIN

SELECT COUNT(*) INTO xnva_count_pre FROM DBXNET.XNVA_D;
    FOR i IN (
        SELECT
            *
        FROM
            dbxnet.sap_shipping_xnva
    ) LOOP
        UPDATE dbxnet.xnva_d
        SET
            condition_type = i.condition_type,
            partner_number = i.partner_number
        WHERE
            kon_sl = i.kon_sl;

        ln_affected_rows := ln_affected_rows + SQL%rowcount;
    END LOOP;
SELECT COUNT(*) INTO xnva_count_post FROM DBXNET.XNVA_D;
    dbms_output.put_line('Number of rows updated xnva_c  ' || ln_affected_rows);
 --INSERT INTO DBXNET.AUDIT_LOG (OPERATION, OPS_DETAILS, AFFECTED_ROWS) VALUES('UPDATE', 'XNVA_UPDATE', xnva_c);
 
if (xnva_count_post <> xnva_count_pre) then  dbms_output.put_line('count mismatch'); 
else  dbms_output.put_line('count matched');
end if;
END;
 -------------------------------------------------------------------------------------------------------------------------------------------------