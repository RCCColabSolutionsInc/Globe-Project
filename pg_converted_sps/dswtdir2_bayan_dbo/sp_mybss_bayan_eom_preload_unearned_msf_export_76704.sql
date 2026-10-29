CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unearned_msf_export()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Export reversal */
/* ============================================= */
DECLARE
    var_Path VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIR2-MyBSS\\Bayan\\ttBayan_Unearned_MSF_New';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_mybss_bayan_eom_preload_unearned_msf_export;
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_mybss_bayan_eom_preload_unearned_msf_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_mybss_bayan_eom_preload_unearned_msf_export (sqlquery, path, filename)
    VALUES ('EXEC [dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Export_LoadFileSel]', var_Path, 'txBayan_Unearned_MSF_LoadFileSel.txt');
    /* Loop from the table */
    /* WHERE CycleCode = @CycleCode */
    OPEN cursor_file;
    FETCH NEXT FROM cursor_file INTO var_sqlQuery, var_path_current, var_fileName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        CALL etl_db_dbo.sp_exporttextfile(var_sqlQuery, var_Path, var_fileName);
        /* Execute export file */
        FETCH NEXT FROM cursor_file INTO var_sqlQuery, var_path_current, var_fileName;
    END LOOP;
    CLOSE cursor_file;
    DROP TABLE IF EXISTS vartable$sp_mybss_bayan_eom_preload_unearned_msf_export;
END;
$procedure$
