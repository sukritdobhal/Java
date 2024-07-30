SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        KTO_NR,
                        SAP_CUST_NUMBER
                        
                FROM
                        DBXNET.SAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.IAK_KTO
                SET
                       SAP_CUST_NUMBER  = I.SAP_CUST_NUMBER
                WHERE
                        KTO_NR = I.KTO_NR;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
END;



SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        FA_KTO_NR
                        
                FROM
                        DBXNET.IAK_D_BCK)
        LOOP
                UPDATE
                        DBXNET.IAK_KTO
                SET
                       FA_KTO_NR  = I.FA_KTO_NR
                WHERE
                        KTO_NR = SUBSTR (I.FA_KTO_NR, 7, 10);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
END;



SET SERVEROUTPUT ON
DECLARE
BEGIN
        FOR I IN
        (
                SELECT
                        FA_NR,
                        KTO_NR,
                        SAP_CUST_NUMBER
                FROM
                        DBXNET.SAPCUST_KTO_MAP)
        LOOP
                UPDATE
                        DBXNET.ULI_M_BCK
                SET
                       SAP_CUST_NUMBER   = I.SAP_CUST_NUMBER,  SAP_VERT_NR ='0'
                WHERE
                        KTO_NR = I.KTO_NR  AND ber_grp='H';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
END;


SELECT *
FROM
        DBXNET.SAPCUST_KTO_MAP
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
                                                                  PARTITION BY KTO_NR,
                                                                               FA_NR
                                                                  ORDER BY KTO_NR,
                                                                           FA_NR
                                                          )
                                        NBLINES
                                FROM
                                        DBXNET.SAPCUST_KTO_MAP) T2
                WHERE
                        NBLINES > 1) ;
                        
                        
                        
                        SELECT fa_nr,kto_nr,sap_cust_number,vert_nr, SAP_VERT_NR FROM dbxnet.uli_m WHERE ber_grp='H';
						
						
						
SELECT DISTINCT(SAP_CUST_NUMBER)
FROM
        DBXNET.SAPCUST_KTO_MAP
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
                                                                  PARTITION BY KTO_NR,
                                                                               SALES_ORG
                                                                  ORDER BY KTO_NR,
                                                                           SALES_ORG
                                                          )
                                        NBLINES
                                FROM
                                        DBXNET.SAPCUST_KTO_MAP) T2
                WHERE
                        NBLINES > 1) ORDER BY KTO_NR DESC;
                        
SELECT * FROM DBXNET.creditreceivables_t;

ALTER TABLE DBXNET.creditreceivables_t ADD CONSTRAINT CREDIT_CONSTRAINT UNIQUE (SAP_CUST_NUMBER, DOC_NUMBER, TRX_TYPE);

SELECT * FROM DBXNET.SAPCUST_KTO_MAP WHERE KTO_NR NOT IN (30514500,
35071832,
30982882,
35050580,
30427400,
35074293) AND KTO_NR IN (SELECT KTO_NR FROM DBXNET.SAPCUST_KTO_MAP GROUP BY KTO_NR HAVING COUNT(KTO_NR)>1);


--SELECT DISTINCT(KTO_NR) FROM DBXNET.SAPCUST_KTO_MAP WHERE KTO_NR IN (

SELECT KTO_NR FROM DBXNET.SAPCUST_KTO_MAP GROUP BY KTO_NR HAVING COUNT(KTO_NR)>1;


SELECT DISTINCT(SAP_CUST_NUMBER) FROM 


SELECT KTO_NR, COUNT(SAP_CUST_NUMBER) FROM DBXNET.SAPCUST_KTO_MAP GROUP BY KTO_NR HAVING COUNT(SAP_CUST_NUMBER) > 1;

SELECT SAP_CUST_NUMBER, COUNT(KTO_NR) FROM DBXNET.SAPCUST_KTO_MAP GROUP BY SAP_CUST_NUMBER HAVING COUNT(KTO_NR) > 1;

SELECT * FROM DBXNET.SAPCUST_KTO_MAP WHERE KTO_NR = 30427459;

SELECT KTO_NR FROM  DBXNET.SAPCUST_KTO_MAP GROUP BY KTO_NR HAVING COUNT(DISTINCT(SAP_CUST_NUMBER)) > 1;
SELECT DISTINCT(KTO_NR) FROM  DBXNET.SAPCUST_KTO_MAP WHERE SAP_CUST_NUMBER IN ( 
SELECT SAP_CUST_NUMBER FROM DBXNET.SAPCUST_KTO_MAP GROUP BY SAP_CUST_NUMBER HAVING COUNT(DISTINCT (SALES_ORG)) > 1);

SELECT * FROM DBXNET.SAPCUST_KTO_MAP WHERE SAP_CUST_NUMBER = '7025610';



BEGIN
  FOR R IN
    ( SELECT 'ALTER TABLE '||TABLE_NAME||' DISABLE CONSTRAINT '||CONSTRAINT_NAME AS STATEMENT
      FROM USER_CONSTRAINTS
      WHERE STATUS = 'ENABLED'
      ORDER BY CASE CONSTRAINT_TYPE WHEN 'R' THEN 1 ELSE 2 END
    )
  LOOP
    EXECUTE IMMEDIATE R.STATEMENT;
  END LOOP;
END



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
                       SAP_VERT_NR  = I.SAP_VERT_NR
                        WHERE VERT_NR = I.VERT_NR;
       END LOOP;
END;
---------------------------------------******************IGAK**************-------------------------------
ALTER SESSION SET CURRENT_SCHEMA = DBXNET;

ALTER TABLE SAPCUST_KTO_MAP DROP COLUMN FA_KTO;

UPDATE SAPCUST_KTO_MAP SET FA_KTO_NR = NULL;

SELECT MAX(LENGTH(FA_NR)) FROM SAPCUST_KTO_MAP WHERE FA_NR NOT LIKE 'GUTB';

SELECT * FROM SAPCUST_KTO_MAP WHERE FA_NR NOT LIKE 'GUTB';

SELECT LENGTH(KTO_NR) FROM SAPCUST_KTO_MAP;

UPDATE SAPCUST_KTO_MAP SET FA_KTO_NR = FA_NR||' '||' '||KTO_NR WHERE FA_NR  LIKE 'GUTB';


SELECT * FROM SAPCUST_KTO_MAP WHERE FA_KTO_NR IN (SELECT FA_KTO_NR FROM IGAK_D);
-------------------------------------------------------------------------------------------------------------
ALTER TABLE DBACLASS.AAF_USER_MEMBER DISABLE CONSTRAINT AAF_USER_FK1;
-------------------------------------------------------------------------------------------------------------
ALTER TABLE DBXNET.MATERIALMASTER_LP ENABLE CONSTRAINT FK_MATMASTER;
--FK_MATMASTER_ORG

ALTER TABLE DBXNET.MATERIALSALESORG ENABLE CONSTRAINT FK_MATMASTER_ORG;
---------------------------------------------------------------------------------------------------------------
SELECT owner,
       original_name,
       operation,
       droptime,
       can_undrop
FROM   dba_recyclebin WHERE OWNER = 'DBXNET';

FLASHBACK TABLE DBXNET.VERT_D TO BEFORE DROP;
---------------------------------------------------------
SELECT * FROM ALL_TABLES WHERE TABLE_NAME = 'VERT_D';
-------------------------------------------------------------
DECLARE
type array_AUKO is table of varchar2(100);
   l_aur_nr array_AUKO;
BEGIN
SELECT auf_nr bulk collect INTO l_aur_nr FROM DBAUFT.AUKO_D A WHERE  TRUNC(SYSDATE) - to_date(A.AUF_DAT,'yyyymmdd') <=1185;
  FOR indx IN l_aur_nr.FIRST .. l_aur_nr.LAST
             LOOP
                DBMS_OUTPUT.put_line (l_aur_nr (indx));
             END LOOP;
END;
----------------------------------------------------------------------


