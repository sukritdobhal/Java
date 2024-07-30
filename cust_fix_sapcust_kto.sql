SET SERVEROUTPUT ON

DECLARE
   TYPE updatecustype IS
      TABLE OF NUMBER INDEX BY VARCHAR2(200);
   updatecustype_tab updatecustype;
   ln_effected       NUMBER := 0;
   i                 VARCHAR2(200);
BEGIN
   updatecustype_tab('0001319012') := 30851309;
   updatecustype_tab('0001319368') := 30981000;
   updatecustype_tab('0001319815') := 30851309;
   updatecustype_tab('0001319823') := 30982869;
   updatecustype_tab('0001319829') := 30982890;
   updatecustype_tab('0001319946') := 30983340;
   updatecustype_tab('0001320309') := 30984188;
   updatecustype_tab('0001320442') := 30984476;
   updatecustype_tab('0001320526') := 30984620;
   updatecustype_tab('0001320540') := 30984634;
   updatecustype_tab('0001331386') := 30982857;
   updatecustype_tab('0001331427') := 30983835;
   i := updatecustype_tab.first;
   WHILE i IS NOT NULL LOOP
      dbms_output.put_line(i
                           || ' '
                           || updatecustype_tab(i));
      dbxnet.cust_fix(i, updatecustype_tab(i));
      i := updatecustype_tab.next(i);
   END LOOP;

END;
---------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE dbxnet.cust_fix (
   v_sap_cust IN VARCHAR2,
   v_kto_nr   IN NUMBER
) IS

   v_present        INTEGER := 0;
   v_fa_kto         VARCHAR2(14) := NULL;
   v_sales_org      VARCHAR2(14) := NULL;
   --v_sales_org_pers VARCHAR2(14) := NULL;
   ln_affected_rows NUMBER := 0;
   no_cust EXCEPTION;
   TYPE t_fa_kto_nr_type IS
      TABLE OF VARCHAR2(50);
   t_fa_kto_nr      t_fa_kto_nr_type := t_fa_kto_nr_type();
   p_cursor         SYS_REFCURSOR;
BEGIN
   SELECT
      COUNT(sap_cust_number)
   INTO v_present
   FROM
      dbxnet.persad_d
   WHERE
      sap_cust_number = v_sap_cust;

   IF ( v_present = 0 ) THEN
      RAISE no_cust;
   ELSIF ( v_present = 1 ) THEN
   <<LOADING_SALES_ORG>>
   BEGIN
       SELECT
         sales_org
      INTO v_sales_org
      FROM
         dbxnet.persad_d
      WHERE
         sap_cust_number = v_sap_cust;

      dbms_output.put_line('SAP_SALES_ORG FOR'
                           || ' '
                           || v_sap_cust
                           || ' IS '
                           || v_sales_org);
	END LOADING_SALES_ORG;
   OPEN p_cursor FOR SELECT
                                          a.fa_kto_nr
                                       FROM
                                               dbfbin.persad_d a
                                          INNER JOIN dbxnet.persad_d b ON a.bez_1 = b.bez_1
                     WHERE
                       b.sap_cust_number = v_sap_cust
                            AND a.kto_nr = v_kto_nr;

   FETCH p_cursor
   BULK COLLECT INTO t_fa_kto_nr;
   CLOSE p_cursor;
   FOR i IN 1..t_fa_kto_nr.count LOOP
      dbms_output.put_line(t_fa_kto_nr(i));
      UPDATE dbxnet.uli_m
      SET
         sap_cust_number = v_sap_cust,
         sales_org = v_sales_org
      WHERE
         kto_nr = v_kto_nr;

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('ULI_M UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.igak_d
      SET
         sap_cust_number = v_sap_cust,
         sales_org = v_sales_org
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('IGAK UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.iak_d
      SET
         sap_cust_number = v_sap_cust,
         sales_org = v_sales_org
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('IAK UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.umpo_d
      SET
         sap_cust_number = v_sap_cust,
         sales_org = v_sales_org
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('UMPO UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
--      UPDATE dbxnet.dfzg_d d
--      SET
--         sap_cust_number = v_sap_cust,
--         sales_org = v_sales_org
--      WHERE
--            fa_kto_nr = v_fa_kto
--         AND d.kunde <> 0;
--
--      ln_affected_rows := SQL%rowcount;
--      dbms_output.put_line('DFZG UPDATED ROWS'
--                           || ' '
--                           || ln_affected_rows);
--      ln_affected_rows := 0;
      UPDATE dbxnet.roif_d
      SET
         sap_cust_number = v_sap_cust,
         sales_org = v_sales_org
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('ROIF UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.auko_d
      SET
         sap_cust_number = v_sap_cust
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('AUKO UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.auko_d
      SET
         sap_order_number = TRIM(auf_nr)
      WHERE
         sap_order_number IS NULL
         AND fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('AUKO UPDATED ROWS SAP_ORDER_NUMBER'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.umsd_d
      SET
         sap_cust_number = v_sap_cust
         --sales_org = v_sales_org
      WHERE
         fa_kto_nr = t_fa_kto_nr(i);

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('UMSD UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
      ln_affected_rows := 0;
      UPDATE dbxnet.kd01_d
      SET
         kdgr = (
            SELECT
               kdgr
            FROM
               dbauft.kd01_d
            WHERE
               fa_kto_nr = t_fa_kto_nr(i)
         )
      WHERE
         sap_cust_number = v_sap_cust;

      ln_affected_rows := SQL%rowcount;
      dbms_output.put_line('KD01 UPDATED ROWS'
                           || ' '
                           || ln_affected_rows);
   END LOOP;
   END IF;

EXCEPTION
   WHEN no_data_found THEN
      dbms_output.put_line('NO OBJECTS_TAB RECORD FOUND FOR OBJECT ');
      ROLLBACK;
   WHEN too_many_rows THEN
      dbms_output.put_line('MULTIPLE OBJECTS_TAB RECORDS FOUND FOR OBJECT ');
      ROLLBACK;
   WHEN no_cust THEN
      dbms_output.put_line('NO CUST  PROPERLY ');
      ROLLBACK;
---------------------------------------------------------------------------------------------------------------------------------------------------
END;



---------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON

DECLARE
   v_sap_cust VARCHAR2(100) := '0001318069';
   v_kto      NUMBER(20) := 1318069;
BEGIN
   dbxnet.cust_fix(v_sap_cust, v_kto);
END;
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
   COUNT(sap_cust_number)
  -- INTO v_present
FROM
   dbxnet.persad_d
WHERE
   sap_cust_number = '0001318069';

SELECT
   fa_kto_nr
      --INTO v_fa_kto
FROM
   dbfbin.persad_d
WHERE
   TRIM(bez_1) IN (
      SELECT
         TRIM(bez_1)
      FROM
         dbxnet.persad_d
   )
   AND kto_nr = 30038678;

SELECT
   *
FROM
   dbfbin.persad_d
WHERE
   kto_nr = 1318069;

SELECT
   *
FROM
   dbauft.kd01_d
WHERE
   kto_nr = 1318069;
----------------------------------------------------------------------------------------------------------------------------------------------
SELECT
   *
FROM
   dbfbin.persad_d
WHERE
   kto_nr = 32656366;

UPDATE dbxnet.persad_d
SET
   fa_kto_nr = 'GUTB  32656366'
WHERE
   sap_cust_number = '0001334090';

SELECT
   *
FROM
   dbfbin.persad_d
WHERE
   kto_nr = 32656366;

UPDATE dbxnet.persad_d
SET
   bez_1 = 'TITAN MACHINERY DEUTSCHLAND GM'
WHERE
   sap_cust_number = '0001334090';
 ---------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------