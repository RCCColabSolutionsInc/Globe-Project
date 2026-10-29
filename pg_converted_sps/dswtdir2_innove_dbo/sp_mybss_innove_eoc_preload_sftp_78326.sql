CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_sftp(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: SFTP */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        exportfilekey
        FROM dswtdir2_innove_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
BEGIN
    var_FileDelKey := 'txInnove_Billed_Cycle_Del';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    /* Loop from the table */
    OPEN cursor_file;
    FETCH NEXT FROM cursor_file INTO var_FileKey;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
        /* Execute export file */
        FETCH NEXT FROM cursor_file INTO var_FileKey;
    END LOOP;
    CLOSE cursor_file;
END;
$procedure$
