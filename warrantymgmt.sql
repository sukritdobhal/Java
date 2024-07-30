SELECT
       *
FROM
       DBXNET.NORI_D
WHERE
       MENU           = 'WE'
AND    TRIM(BENUTZER) = 'john deere';
--Aanderssdk
--aanderssDK
SELECT
         menu       ,
         resourcekey,
         i18n.resourcetext
FROM
         dbxnet.act_d act
JOIN
         dbxnet.i18n_d i18n
ON
         i18n.resource_key = RPAD (act.resourcekey, 60)
AND      languageid        = 'en'
WHERE
         menu IN
         (
                  SELECT
                           link
                  FROM
                           dbxnet.menu_d menu
                  WHERE
                           link <> ' '
                  GROUP BY
                           link)
order by
         i18n.resourcetext;
		 
		--rxm0915      
		 
		 
SET DEFINE OFF;
Insert into DBXNET.NORI_D (REIHENFOLGE,FA_NR,BER_GRP,MENU,LINK,BENUTZER) values (15,'GUTB  ','    ','WE  ','    ','rxm0915     ');
Insert into DBXNET.NORI_D (REIHENFOLGE,FA_NR,BER_GRP,MENU,LINK,BENUTZER) values (10,'GUTB  ','    ','WE  ','WM  ','rxm0915     ');
Insert into DBXNET.NORI_D (REIHENFOLGE,FA_NR,BER_GRP,MENU,LINK,BENUTZER) values (10,'GUTB  ','    ','WE  ','WE  ','rxm0915     ');
Insert into DBXNET.NORI_D (REIHENFOLGE,FA_NR,BER_GRP,MENU,LINK,BENUTZER) values (10,'GUTB  ','    ','WE  ','WO  ','rxm0915     ');
