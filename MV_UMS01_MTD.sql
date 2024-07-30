-- DBXNET.MV_UMS01_MTD source

CREATE MATERIALIZED VIEW "DBXNET"."MV_UMS01_MTD" ("VERT_NR1", "VERT_NR2", "FA_NR", "KTO_NR", "BEZ1", "STR", "PLZ_LA", "ZIPCODE", "ORT", "TEL", "FAX", "BRA_SL_1", "BRA_SL_2", "BRA_SL_3", "BRA_SL_4", "BRA_SL_5", "MATCHCODE", "KDGR", "WG_IDENT", "PR_IDENT", "PL_IDENT", "REF_NR", "UNTERKLASSE", "GBUB", "UMS_KZ", "KL_KZ", "AUFART_KZ", "VKWG", "AUFTR_KANAL", "TEILENR", "TNRDUMMY", "UMS_REF_NR", "DATUM", "STAT_MENGE", "GES_WERT_FW", "ORDAT_SEQUENCE")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 0 INITRANS 2 MAXTRANS 255 
 NOCOMPRESS NOLOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "ORDAT_TABLESPACE" 
  BUILD DEFERRED
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT kdu.vert_nr1,
         kdu.vert_nr2,
         umsd.fa_nr,
         umsd.kto_nr,
         kdu.bez1,
         kdu.str,
         kdu.plz_la,
         kdu.zipcode,
         kdu.ort,
         kd01.TEL_TAB6_1                  AS tel,
         kd01.TEL_TAB6_3                  AS fax,
         kd01.BRA_SL_1,
         kd01.BRA_SL_2,
         kd01.BRA_SL_3,
         kd01.BRA_SL_4,
         kd01.BRA_SL_5,
         kdu.matchcode,
         kdu.kdgr,
         wg_ident,
         pr_ident,
         pl_ident,
         ref_nr,
         unterklasse,
         SUBSTR (umsd.fa_gubkto, 7, 2)    AS gbub,
         (CASE
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = '5'
              THEN
                  'ET'
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = 'K'
              THEN
                  'KD'
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = '4'
              THEN
                  'RM'
              WHEN     SUBSTR (pr_ident, 1, 2) >= '10'
                   AND SUBSTR (pr_ident, 1, 2) <= '80'
              THEN
                  'FW'
              ELSE
                  ' '
          END)                            UMS_KZ,
         umsd.kl_kz,
         umsd.aufart_kz,
         umsd.VKWG,
         umsd.auftr_kanal,
         umsd.teilenr,
         umsd.tnrdummy,
         umsd.ums_ref_nr,
         umsd.datum,
         SUM (menge / 1000)               AS stat_menge,
         SUM (ges_wert_fw / 100)          AS ges_wert_fw,
         MIN (umsd.ordat_sequence)        AS ordat_sequence
    FROM dbstmt.umsd_d umsd,
         dbstmt.kdu_m kdu,
         dbstmt.tnst_m tnst,
         dbauft.kd01_d kd01
   WHERE     kdu.fa_gubkto = umsd.fa_gubkto
         AND kd01.FA_KTO_NR = kdu.FA_KTO_NR
         AND tnst.teilenr = umsd.teilenr
         AND UMSD.SATZART = 'UM'
         AND UMSD.KL_KZ = '0'
GROUP BY kdu.vert_nr1,
         kdu.vert_nr2,
         umsd.fa_nr,
         umsd.kto_nr,
         kdu.bez1,
         kdu.str,
         kdu.plz_la,
         kdu.zipcode,
         kdu.ort,
         kd01.TEL_TAB6_1,
         kd01.TEL_TAB6_1,
         kd01.TEL_TAB6_3,
         kd01.BRA_SL_1,
         kd01.BRA_SL_2,
         kd01.BRA_SL_3,
         kd01.BRA_SL_4,
         kd01.BRA_SL_5,
         kdu.matchcode,
         kdu.kdgr,
         wg_ident,
         pr_ident,
         pl_ident,
         ref_nr,
         unterklasse,
         SUBSTR (umsd.fa_gubkto, 7, 2),
         (CASE
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = '5'
              THEN
                  'ET'
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = 'K'
              THEN
                  'KD'
              WHEN SUBSTR (umsd.fa_gubkto, 7, 1) = '4'
              THEN
                  'RM'
              WHEN     SUBSTR (pr_ident, 1, 2) >= '10'
                   AND SUBSTR (pr_ident, 1, 2) <= '80'
              THEN
                  'FW'
              ELSE
                  ' '
          END),
         umsd.kl_kz,
         umsd.aufart_kz,
         umsd.vkwg,
         umsd.auftr_kanal,
         umsd.teilenr,
         umsd.tnrdummy,
         umsd.ums_ref_nr,
         umsd.datum
  HAVING SUM (umsd.menge) <> 0 OR SUM (ges_wert_fw) <> 0;

COMMENT ON MATERIALIZED VIEW DBXNET.MV_UMS01_MTD IS 'snapshot table for snapshot DBXNET.MV_UMS01_MTD';