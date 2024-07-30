-------------------------------------------------MENU DELTION QUERIES---------------------------------
-----BE SURE TO TABLE BACK-UP---------------------------------------------------------------------------
-----------------TO DELETE MY ROBOMOWER------------------------------------------------

DELETE FROM DBXNET.MENU_D WHERE MENU='MRIF ';

--TO DELETE TURNOVER PER CUSTOMER--------------------------------------------------------------------

DELETE FROM DBXNET.MENU_D WHERE MENU='CI  ' AND  trim(LINK) = 'TCU' AND FA_NR ='      '  AND PROJEKT ='Portal          ';
-------------------------------------------------------------------------------------------------------------------------------------
---FOC
DELETE FROM DBXNET.MENU_D WHERE (LINK = 'FO  ' OR LINK = 'FOOV');