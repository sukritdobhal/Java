
----------------------CHECK TABLESPACE-----WE NEED THE ORDAT TABLESPACE-----
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;
------------------------------------------------------------------------------
SHOW CON_NAME; --- SHOULD BE FOSSTEST
-----------------------------------------------------------------------------
SHOW PDBS;  -- SHOULD BE FOSSTEST
--------------------------------------------------------------------------
ALTER SESSION SET CONTAINER = <PDB>;
-------------------------------------------------------------------------------------
--ROUSERN
CREATE USER ROUSER IDENTIFIED BY ROUSER DEFAULT TABLESPACE ORDAT_TABLESPACE TEMPORARY TABLESPACE TEMP;
---------------------------------------------------------------------------------------------------
CREATE ROLE RO_ROLE;
---------------------------------------------------------------------------------------------------------
BEGIN
        FOR X IN
        (
                SELECT
                        *
                FROM
                        DBA_TABLES
                WHERE
                        OWNER='DBXNET')
        LOOP
                EXECUTE IMMEDIATE 'GRANT SELECT ON SCHEMA_NAME.' || X.TABLE_NAME || ' TO RO_ROLE';
        END LOOP;
END;
----------------------------------------------------------------------------------------------------------
GRANT RO_ROLE TO ROUSER;
------------------------------------------------------------------------------------------------------