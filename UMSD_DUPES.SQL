----------------------------------------------------------------------------------------------------------------------------------------------
SELECT
         menge           ,
         ges_wert_fw     ,
         ordat_sequence  ,
         sap_order_number,
         teilenr         ,
         auftr_kanal     ,
         datum
FROM
         dbxnet.umsd_d
WHERE
         sap_order_number IN
         (
                SELECT
                       sap_order_number
                FROM
                       dbxnet.umsd_d
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
                                                                             PARTITION BY sap_order_number,
                                                                                     teilenr
                                                                             ORDER BY sap_order_number,
                                                                                     teilenr
                                                                     )
                                                   nblines
                                            FROM
                                                   dbxnet.umsd_d ) t2
                              WHERE
                                     nblines > 1 ) )
ORDER BY
         sap_order_number DESC;
----------------------------------------------------------------------------------------------------------------------------------------------
SELECT
         COUNT(*)
FROM
         dbxnet.umsd_d
WHERE
         sap_order_number IN
         (
                SELECT
                       sap_order_number
                FROM
                       dbxnet.umsd_d
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
                                                                             PARTITION BY sap_order_number,
                                                                                     teilenr
                                                                             ORDER BY sap_order_number,
                                                                                     teilenr
                                                                     )
                                                   nblines
                                            FROM
                                                   dbxnet.umsd_d ) t2
                              WHERE
                                     nblines > 1 ) )
ORDER BY
         sap_order_number DESC;
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT
       MENGE           ,
       GES_WERT_FW     ,
       ORDAT_SEQUENCE  ,
       SAP_ORDER_NUMBER,
       TEILENR
FROM
       DBXNET.UMSD_D
where
       fa_nr is null
AND    TRIM(TEILENR) IN
       (
              SELECT
                     TRIM(TEILENR)
              FROM
                     DBXNET.GAZK_D)
AND    AUFART_KZ = 'WC';
SELECT
       *
FROM
       DBXNET.IGAK_D
WHERE
       TRIM(SAP_CREDIT_NUMBER) = '9932883313';
--3861781
SELECT
       *
FROM
       DBXNET.IGAP_D
WHERE
       ORDERID = 3860696;
SELECT
       *
FROM
       DBXNET.IGAP_D
WHERE
       ORDERID IN
       (
              SELECT
                     ORDERID
              FROM
                     DBXNET.IGAK_D
              WHERE
                     TRIM(SAP_CREDIT_NUMBER) IN
                     (
                            SELECT
                                   TRIM(SAP_ORDER_NUMBER)
                            FROM
                                   DBXNET.UMSD_D
                            where
                                   fa_nr is null
                            AND    TRIM(TEILENR) IN
                                   (
                                          SELECT
                                                 TRIM(TEILENR)
                                          FROM
                                                 DBXNET.GAZK_D)
                            AND    AUFART_KZ = 'WC'));
SELECT
       MENGE           ,
       GES_WERT_FW     ,
       ORDAT_SEQUENCE  ,
       SAP_ORDER_NUMBER,
       TEILENR
FROM
       DBXNET.UMSD_D
where
       fa_nr is null
AND    TRIM(TEILENR) IN
       (
              SELECT
                     TRIM(TEILENR)
              FROM
                     DBXNET.GAZK_D)
AND    AUFART_KZ            = 'WC'
AND    REMAINDER(MENGE,100) =0;
-------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
DECLARE
        v_with_remainder    NUMBER := 0;
        v_without_remainder NUMBER := 0;
BEGIN
        FOR x IN
        (
               SELECT
                      menge      ,
                      ges_wert_fw,
                      ordat_sequence
               FROM
                      dbxnet.umsd_d
               WHERE
                      menge < 0
               AND    fa_nr IS NULL
               AND    TRIM(teilenr) IN
                      (
                             SELECT
                                    TRIM(teilenr)
                             FROM
                                    dbxnet.gazk_d )
               AND    aufart_kz = 'WC' )
        LOOP
               UPDATE
                      dbxnet.umsd_d
               SET
                      menge       = x.ges_wert_fw,
                      ges_wert_fw = x.menge
               WHERE
                      menge < 0
               AND    fa_nr IS NULL
               AND    TRIM(teilenr) IN
                      (
                             SELECT
                                    TRIM(teilenr)
                             FROM
                                    dbxnet.gazk_d )
               AND    aufart_kz             = 'WC'
               AND    remainder(menge, 100) = 0;
               v_without_remainder := v_without_remainder + SQL%rowcount;
               UPDATE
                      dbxnet.umsd_d
               SET
                      menge       = x.ges_wert_fw,
                      ges_wert_fw = x.menge * 100
               WHERE
                      menge < 0
               AND    fa_nr IS NULL
               AND    TRIM(teilenr) IN
                      (
                             SELECT
                                    TRIM(teilenr)
                             FROM
                                    dbxnet.gazk_d )
               AND    aufart_kz             = 'WC'
               AND    remainder(menge, 100) <> 0;
               v_with_remainder := v_with_remainder + SQL%rowcount;
        END LOOP;
        dbms_output.put_line(v_with_remainder);
        dbms_output.put_line(v_without_remainder);
END;
---------------------------------------------------------------------------------------------------------------------------------
DELETE
FROM
       DBXNET.UMSD_D
where
       fa_nr is null
AND    TRIM(TEILENR) IN
       (
              SELECT
                     TRIM(TEILENR)
              FROM
                     DBXNET.GAZK_D)
AND    AUFART_KZ        = 'WC'
AND    SAP_ORDER_NUMBER = '        ';
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
       SAP_ORDER_NUMBER,
       TEILENR
FROM
       DBXNET.UMSD_D
where
       fa_nr is null
AND    TRIM(TEILENR) IN
       (
              SELECT
                     TRIM(TEILENR)
              FROM
                     DBXNET.GAZK_D)
AND    AUFART_KZ = 'WC'
AND    SAP_ORDER_NUMBER IS NOT NULL;
 ------------------------------------------------------------------------------------------------------------------------------------------------