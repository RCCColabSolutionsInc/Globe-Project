CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Path VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIP2-IOT_DA\\IOT_DA_New';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_iot_da_export;
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_iot_da_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_iot_da_export (sqlquery, path, filename)
    VALUES ('EXEC [dswTDIP2_IOT_DA].[dbo].[sp_IOT_DA_Export_OutTap]', var_Path, 'txIOT_DA_OutTap_LoadFile.txt'),
    ('EXEC [dswTDIP2_IOT_DA].[dbo].[sp_IOT_DA_Export_InTap]', var_Path, 'txIOT_DA_InTap_LoadFile.txt');
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
    DROP TABLE IF EXISTS vartable$sp_iot_da_export;
END;
$procedure$
