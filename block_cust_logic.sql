CREATE OR REPLACE PROCEDURE dbxnet.is_blocked (
   sap_cust VARCHAR2
) AS

   CURSOR per_cursor IS
   SELECT
      p.limit_1,
      p.credit_status,
      p.sap_cust_number
   FROM
      dbxnet.persad_d p
   WHERE
         p.sap_cust_number = sap_cust
      AND REGEXP_LIKE ( p.credit_status,
                        '^[^a-zA-Z]*$' );

   var_per   per_cursor%rowtype;
   v_cred    NUMBER;
   v_diff    NUMBER;
   v_limit_1 NUMBER;
BEGIN
        --DBMS_OUTPUT.PUT_LINE('THE CUST NUMBER=' || SAP_CUST);
   IF per_cursor%isopen THEN
      CLOSE per_cursor;
   END IF;
   OPEN per_cursor;
   LOOP
      FETCH ` INTO var_per;
      EXIT WHEN per_cursor%notfound;
                --DBMS_OUTPUT.PUT_LINE('THE CREDIT_STATUS=' ||var_per.CREDIT_STATUS );
                --DBMS_OUTPUT.PUT_LINE('THE LIMIT_1=' ||var_per.LIMIT_1 );
      v_cred := TO_NUMBER ( var_per.credit_status );
      v_limit_1 := TO_NUMBER ( var_per.limit_1 );
      v_diff := v_limit_1 - v_cred;
                --DBMS_OUTPUT.PUT_LINE('THE DIFFERENCE IS=' ||v_diff );
      IF ( v_diff >= 0 ) THEN
                       -- DMBS_LOCK.SLEEP(10);
         UPDATE dbxnet.kd01_d
         SET
            is_blocked = 0
         WHERE
            sap_cust_number = var_per.sap_cust_number;
                             --   COMMIT;
      ELSIF ( v_diff < 0 ) THEN
         UPDATE dbxnet.kd01_d
         SET
            is_blocked = 1
         WHERE
            sap_cust_number = var_per.sap_cust_number;
                             --   COMMIT;
      ELSE
                                -- ROLLBACK;
         EXECUTE IMMEDIATE Q'[INSERT INTO DBXNET.LOG_ERR_TABLE(ERROR_MESSAGE) VALUES('ISSUE IN BLOCK CUST LOGIC SP')]';
                               -- COMMIT;
      END IF;

   END LOOP;

   CLOSE per_cursor;
   COMMIT;
END;

-------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER "DBXNET"."BLOCK_CUST" AFTER
    INSERT OR UPDATE ON DBXNET.PERSAD_D
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
DECLARE
pragma autonomous_transaction;
SAP_CUST VARCHAR2(200);
BEGIN
SAP_CUST := :NEW.SAP_CUST_NUMBER;
    dbxnet.is_blocked(SAP_CUST);
END;


ALTER TRIGGER "DBXNET"."BLOCK_CUST" ENABLE;
--------------------------------------------------------------------------------------------------------------------------
---------------------------CREDIT STATUS SHOULD NOT CONTAIN ANY ALPHA NUMERIC VALUES---------------------------------------
SET SERVEROUTPUT ON
DECLARE
    v_cred  NUMBER;
    v_diff  NUMBER;
    v_limit_1 NUMBER;
    a number := 0;
    b number := 0;
    CURSOR per_cursor IS
    SELECT
        p.limit_1,
        p.credit_status,
        p.sap_cust_number
    FROM
        dbxnet.persad_d p;

    var_per per_cursor%rowtype;
BEGIN
    IF per_cursor%isopen THEN
        CLOSE per_cursor;
    END IF;
    OPEN per_cursor;
    LOOP
        FETCH per_cursor INTO var_per;
        EXIT WHEN per_cursor%notfound;
        v_cred := TO_NUMBER ( var_per.credit_status );
        v_limit_1 := TO_NUMBER ( var_per.limit_1 );
        v_diff := v_limit_1 - v_cred;
        IF ( v_diff >= 0 ) THEN
        
        UPDATE DBXNET.KD01_D SET IS_BLOCKED = 0 WHERE SAP_CUST_NUMBER = VAR_PER.SAP_CUST_NUMBER;
        a := a + SQL%ROWCOUNT;
        
            dbms_output.put_line('THE NOT TO BE BLOCKED CUSTOMERS=' || var_per.sap_cust_number||' '|| v_cred||' '|| v_limit_1 );
        ELSIF ( v_diff < 0 ) THEN
        UPDATE DBXNET.KD01_D SET IS_BLOCKED = 1 WHERE SAP_CUST_NUMBER = VAR_PER.SAP_CUST_NUMBER;
        b := b + SQL%ROWCOUNT;
            dbms_output.put_line('THE TO BE BLOCKED CUSTOMERS=' || var_per.sap_cust_number||' '|| v_cred||' '|| v_limit_1 );
        ELSE
                                -- ROLLBACK;
            NULL;
        END IF;

    END LOOP;

    CLOSE per_cursor;
    dbms_output.put_line(a||' '||b);
END;

-----------------------------------------------------------------------------------------------------------------------------------------------
---------this query will give you the list of blocked customers that should be blocked but are not--------
SELECT SAP_CUST_NUMBER
     FROM dbxnet.persad_d d
    WHERE (d.limit_1 - TO_NUMBER ( d.credit_status )) <= 0
MINUS
SELECT SAP_CUST_NUMBER FROM DBXNET.KD01_D WHERE IS_BLOCKED = 1;
 
----------------for the above returned sap_cust_numbers check whether they exist in kd01 or not---------------------
SELECT limit_1,credit_status  FROM DBXNET.PERSAD_D WHERE SAP_CUST_NUMBER = '1000193008';
SELECT *  FROM DBXNET.KD01_D WHERE SAP_CUST_NUMBER = '0001153476';
--------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------TESTING------------------------------------------------------------------------
SELECT LIMIT_1, CREDIT_STATUS, ORDAT_SEQUENCE, SAP_CUST_NUMBER FROM DBXNET.PERSAD_D WHERE CREDIT_STATUS IS NOT NULL;

--176
--0001373758

SELECT IS_BLOCKED FROM DBXNET.KD01_D WHERE SAP_CUST_NUMBER = '0001373758'; --1
UPDATE DBXNET.KD01_D SET IS_BLOCKED = NULL WHERE SAP_CUST_NUMBER = '0001373758';
COMMIT;

UPDATE DBXNET.PERSAD_D SET LIMIT_1 = 0, CREDIT_STATUS = '1000' WHERE SAP_CUST_NUMBER = '0001373758';

SELECT * FROM DBXNET.PERSAD_D WHERE SAP_CUST_NUMBER = '0001373758';
----------------------------------------------------------------------------------------------------------------------------------------------------