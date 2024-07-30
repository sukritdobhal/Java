 --SET SERVEROUTPUT ON
BEGIN
   FOR i IN (
      SELECT
         *
      FROM
         dbxnet.missing_cust
      WHERE
         sap_cust_number IN (
            SELECT
               sap_cust_number
            FROM
               dbxnet.persad_d
         )
   ) LOOP
      dbxnet.cust_fix(i.sap_cust_number, i.kto_nr);
   END LOOP;
END;