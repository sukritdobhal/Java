set serveroutput on

DECLARE
   ln_effected NUMBER := 0;
   mn_effected NUMBER := 0;
   on_effected NUMBER := 0;
BEGIN
   BEGIN
      FOR i IN (
         SELECT
            a.orderid,
            b.sap_order_number,
            a.alte_teilenr,
            a.net_pr_fw,
            c.sach_nr,
            c.netto_pr_fw,
            b.sap_cust_number,
            a.po_itemnumber
         FROM
                 dbxnet.iap_d a
            INNER JOIN dbxnet.iak_d  b ON a.orderid = b.orderid
            INNER JOIN dbxnet.aupo_d c ON c.sap_order_number = b.sap_order_number
         WHERE
               b.is_migrated = 0
            AND trim(c.sach_nr) = trim(a.NEUE_TEILENR)-------------------NEUE_TEILENR &TRIM
            AND c.po_itemnumber = a.po_itemnumber
            AND b.last_mod_date <= 20240608
			AND C.netto_pr_fw <> A.net_pr_fw * 100;
      ) LOOP
         UPDATE dbxnet.aupo_d
         SET
            netto_pr_fw = i.net_pr_fw * 100
         WHERE
               sap_order_number = i.sap_order_number
            AND TRIM(sach_nr) = trim(i.NEUE_TEILENR
            AND po_itemnumber = i.po_itemnumber
			AND	netto_pr_fw <> i.net_pr_fw * 100;		----------------AND netto_pr_fw <> i.net_pr_fw * 100

         ln_effected := ln_effected + SQL%rowcount;
      END LOOP;
   END;

   BEGIN
      FOR x IN (
         SELECT
            a.orderid,
            b.sap_order_number,
            a.alte_teilenr,
            a.net_pr_fw,
            c.sach_nr,
            c.netto_pr_fw,
            d.sap_cust_number,
            d.ordat_sequence AS umsd_ordat,
            e.ordat_sequence AS umpo_ordat
         FROM
                 dbxnet.iap_d a
            INNER JOIN dbxnet.iak_d  b ON a.orderid = b.orderid
            INNER JOIN dbxnet.aupo_d c ON c.sap_order_number = b.sap_order_number
            INNER JOIN dbxnet.umsd_d d ON d.sap_order_number = b.sap_order_number
            INNER JOIN dbxnet.umpo_d e ON e.sap_cust_number = d.sap_cust_number
         WHERE
               b.is_migrated = 0
            AND trim(c.sach_nr) = trim(a.alte_teilenr)
            AND d.teilenr = c.sach_nr
            AND e.teilenr = d.teilenr
            AND b.last_mod_date <= 20240608
			AND d.ges_wert_fw <> a.net_pr_fw *100
			AND e.ges_wert_fw <> a.net_pr_fw *100
      ) LOOP
         UPDATE dbxnet.umsd_d
         SET
            ges_wert_fw = x.net_pr_fw * 100
         WHERE
               sap_order_number = x.sap_order_number
            AND teilenr = x.sach_nr
            AND ordat_sequence = x.umsd_ordat
			AND ges_wert_fw <> x.net_pr_fw * 100;

         mn_effected := mn_effected + SQL%rowcount;
         UPDATE dbxnet.umpo_d
         SET
            ges_wert_fw = x.net_pr_fw * 100
         WHERE
               auf_nr = x.sap_order_number
            AND teilenr = x.sach_nr
            AND ordat_sequence = x.umpo_ordat
			AND ges_wert_fw <> x.net_pr_fw * 100;

         on_effected := on_effected + SQL%rowcount;
      END LOOP;

--      UPDATE dbxnet.umpo_d
--      SET
--         stat_menge = stat_menge / 1000
--      WHERE
--         is_migrated = 1;
--
--      UPDATE dbxnet.umpo_d
--      SET
--         stat_menge = stat_menge / 100
--      WHERE
--            is_migrated = 0
--         AND stat_menge < 0;

      dbms_output.put_line('auko'
                           || ' '
                           || ln_effected);
      dbms_output.put_line('umsd'
                           || ' '
                           || mn_effected);
      dbms_output.put_line('umpo'
                           || ' '
                           || on_effected);
   END;

END;

-------------------------------------------------------------------------------------------------------------------------------------
      
            
            -- CREATE INDEX PART_NUMBER_AUPO ON DBXNET.aupo_d(SACH_NR);
            
            -- ANALYZE INDEX PART_NUMBER_AUPO VALIDATE STRUCTURE;
            
            -- CREATE INDEX PART_NUMBER_IAP ON DBXNET.IAP_D(alte_teilenr);
            
            -- ANALYZE INDEX PART_NUMBER_IAP VALIDATE STRUCTURE;
            
             -- CREATE INDEX PART_NUMBER_UMPO ON DBXNET.UMPO_D(teilenr);
             
              -- ANALYZE INDEX PART_NUMBER_UMPO VALIDATE STRUCTURE;
              
              -- CREATE INDEX PART_NUMBER_UMSD ON DBXNET.UMSD_D(teilenr);
              
              -- ANALYZE INDEX PART_NUMBER_UMSD VALIDATE STRUCTURE;
			  -- CREATE TABLE DBXNET.AUPO_D_BCKP061124 AS SELECT * FROM DBXNET.AUPO_D;
-- CREATE TABLE DBXNET.UMPO_D_BCKP061124 AS SELECT * FROM DBXNET.UMPO_D;
-- CREATE TABLE DBXNET.UMSD_D_BCKP061124 AS SELECT * FROM DBXNET.UMSD_D;