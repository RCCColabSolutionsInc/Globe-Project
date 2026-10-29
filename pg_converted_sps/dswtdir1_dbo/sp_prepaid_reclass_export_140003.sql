CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_prepaid_reclass_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Path VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIR1-Prepaid\\Prepaid_New';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_prepaid_reclass_export;
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_prepaid_reclass_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_prepaid_reclass_export (sqlquery, path, filename)
    VALUES ('EXEC [dswTDIR1].[dbo].[sp_Prepaid_Reclass_Export_EG_Sel]', var_Path, 'txPrepaid_JV_EGSel.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Prepaid_Reclass_Export_SG_Sel]', var_Path, 'txPrepaid_JV_SGSel.txt');
    /* Loop from the table */
    OPEN cursor_file;
    FETCH NEXT FROM cursor_file INTO var_sqlQuery, var_path_current, var_fileName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        CALL etl_db_dbo.sp_exporttextfile(var_sqlQuery, var_path_current, var_fileName);
        /* Execute export file */
        FETCH NEXT FROM cursor_file INTO var_sqlQuery, var_path_current, var_fileName;
    END LOOP;
    CLOSE cursor_file;
    DROP TABLE IF EXISTS vartable$sp_prepaid_reclass_export;
END;
$procedure$
