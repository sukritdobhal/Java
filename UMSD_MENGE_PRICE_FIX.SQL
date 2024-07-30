SET SERVEROUTPUT ON

DECLARE
   TYPE pricerectype IS RECORD (
         orderid          dbxnet.igap_d.orderid%TYPE,
         menge            dbxnet.igap_d.menge%TYPE,
         net_pr_fw        dbxnet.igap_d.net_pr_fw%TYPE,
         sap_order_number dbxnet.umsd_d.sap_order_number%TYPE,
         teilenr          dbxnet.umsd_d.teilenr%TYPE,
         ordat_sequence   dbxnet.umsd_d.ordat_sequence%TYPE
   );
   TYPE price_tab IS
      TABLE OF pricerectype;
   pricerec    price_tab;
   ln_effected NUMBER := 0;
BEGIN
   SELECT DISTINCT
      ( a.orderid ),
      a.menge,
      a.net_pr_fw,
      c.sap_order_number,
      c.teilenr,
      c.ordat_sequence
   BULK COLLECT
   INTO pricerec
   FROM
           dbxnet.igap_d a
      INNER JOIN dbxnet.igak_d b ON a.orderid = b.orderid
      INNER JOIN dbxnet.umsd_d c ON b.sap_credit_number = c.sap_order_number
   WHERE
      c.fa_nr IS NULL
      AND c.kto_nr IS NULL
      AND TRIM(a.teilenr) LIKE '999%'
      AND TRIM(c.teilenr) IN (
         SELECT
            TRIM(teilenr)
         FROM
            dbxnet.gazk_d
      )
      AND c.aufart_kz = 'WC';

   BEGIN
      FOR i IN pricerec.first..pricerec.last LOOP
--DBMS_OUTPUT.PUT_LINE(pricerec(i).orderid ||' '||  pricerec(i).menge );
         UPDATE dbxnet.umsd_d
         SET
            menge = pricerec(i).net_pr_fw,
            ges_wert_fw = pricerec(i).menge / 100
         WHERE
               sap_order_number = pricerec(i).sap_order_number
            AND teilenr = pricerec(i).teilenr
            AND ordat_sequence = pricerec(i).ordat_sequence;

         ln_effected := ln_effected + SQL%rowcount;
      END LOOP;

   END;

   dbms_output.put_line(ln_effected);
END;