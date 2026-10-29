CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_export()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIP2_Actualization */
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: July 27, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_Path VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIP2-Actualization\\ISMS\\Actualization_ISMS_New';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_actualization_isms_preload_export;
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_actualization_isms_preload_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_actualization_isms_preload_export (sqlquery, path, filename)
    VALUES ('EXEC [dswTDIP2_Actualization].[dbo].[sp_Actualization_ISMS_Preload_Export_LoadFileSel]', var_Path, 'Actualization_ISMS_ZF_OPENBAL.txt');
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
    DROP TABLE IF EXISTS vartable$sp_actualization_isms_preload_export;
END;
$procedure$
