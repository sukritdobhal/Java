CREATE OR REPLACE PROCEDURE DBXNET.DEL_SLBK_D
IS
BEGIN
        FOR ITEM IN
        (
                SELECT
                        *
                FROM
                        SLBK_D sd
                WHERE
                        SYSDATE - to_date(sd.letzt_aend,'YYYYMMDD') > 21
                ORDER BY
                        LETZT_AEND DESC )
        LOOP DBMS_OUTPUT.PUT_LINE ('customer number = ' || ITEM.KTO_NR || ', USERNAME = ' || ITEM.BENUTZERX12);
                DELETE
                FROM
                        SLBK_D WHERE BENUTZERX12 = ITEM.BENUTZERX12;
                -- DBMS_OUTPUT.PUT_LINE('Sales Basked removed for Customer ' || slbk_d_rec.KTO_NR);
        END LOOP;
        COMMIT;
EXCEPTION
        -- Handles all errors
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('The transaction has been rolled back due to errors, please try again.');
        ROLLBACK;
END DEL_SLBK_D;