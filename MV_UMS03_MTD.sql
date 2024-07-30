-- DBXNET.MV_UMS03_MTD source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "DBXNET"."MV_UMS03_MTD" ("FA_NR", "KTO_NR", "TEL", "FAX", "BRA_SL_1", "BRA_SL_2", "BRA_SL_3", "BRA_SL_4", "BRA_SL_5", "KL_KZ", "AUFART_KZ", "VKWG", "AUFTR_KANAL", "TEILENR", "DATUM", "STAT_MENGE", "GES_WERT_FW", "ORDAT_SEQUENCE", "SAP_CUST_NUMBER", "UMS_REF_NR", "REF_NR") AS 
  SELECT   umsd.fa_nr,
         umsd.kto_nr,
         kd01.TEL_TAB6_1                  AS tel,
         kd01.TEL_TAB6_3                  AS fax,
         kd01.BRA_SL_1,
         kd01.BRA_SL_2,
         kd01.BRA_SL_3,
         kd01.BRA_SL_4,
         kd01.BRA_SL_5,
         umsd.kl_kz,
         umsd.aufart_kz,
         umsd.VKWG,
         umsd.auftr_kanal,
         umsd.teilenr,
         umsd.datum,
         SUM (menge / 1000)               AS stat_menge,
         SUM (ges_wert_fw / 100)          AS ges_wert_fw,
         MIN (umsd.ordat_sequence)        AS ordat_sequence,
		 umsd.SAP_CUST_NUMBER,
		 umsd.UMS_REF_NR,
         umsd.ref_nr
    FROM dbxnet.umsd_d umsd,
         dbxnet.kd01_d kd01
   WHERE umsd.SAP_CUST_NUMBER = kd01.SAP_CUST_NUMBER
         AND UMSD.KL_KZ = '0'
GROUP BY umsd.fa_nr,
         umsd.kto_nr,
         kd01.TEL_TAB6_1,
         kd01.TEL_TAB6_3,
         kd01.BRA_SL_1,
         kd01.BRA_SL_2,
         kd01.BRA_SL_3,
         kd01.BRA_SL_4,
         kd01.BRA_SL_5,
         umsd.kl_kz,
         umsd.aufart_kz,
         umsd.vkwg,
         umsd.auftr_kanal,
         umsd.teilenr,
         umsd.datum,
         UMSD.MENGE,
         UMSD.ges_wert_fw,
		 umsd.ordat_sequence,
		 umsd.SAP_CUST_NUMBER,
		 umsd.UMS_REF_NR,
          umsd.ref_nr
  HAVING SUM (umsd.menge) <> 0 OR SUM (ges_wert_fw) <> 0;