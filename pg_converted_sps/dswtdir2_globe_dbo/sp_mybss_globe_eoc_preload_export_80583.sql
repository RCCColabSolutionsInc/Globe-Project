CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_export(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: Export */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_Path VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIR2-MyBSS\\Globe\\ttGlobe_DP1_Billed_New';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_mybss_globe_eoc_preload_export
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_mybss_globe_eoc_preload_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_mybss_globe_eoc_preload_export (cyclecode, sqlquery, path, filename)
    VALUES ('EOC1', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC01"', var_Path, 'txGlobe_DP1_Billed_Cycle1LoadFileSel.txt'),
    ('EOC2', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC06"', var_Path, 'txGlobe_DP1_Billed_Cycle2LoadFileSel.txt'),
    ('EOC3', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC08"', var_Path, 'txGlobe_DP1_Billed_Cycle3LoadFileSel.txt'),
    ('EOC4', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC10"', var_Path, 'txGlobe_DP1_Billed_Cycle4LoadFileSel.txt'),
    ('EOC5', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC11"', var_Path, 'txGlobe_DP1_Billed_Cycle5LoadFileSel.txt'),
    ('EOC6', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC13"', var_Path, 'txGlobe_DP1_Billed_Cycle6LoadFileSel.txt'),
    ('EOC7', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC16"', var_Path, 'txGlobe_DP1_Billed_Cycle7LoadFileSel.txt'),
    ('EOC8', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC18"', var_Path, 'txGlobe_DP1_Billed_Cycle8LoadFileSel.txt'),
    ('EOC9', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC21"', var_Path, 'txGlobe_DP1_Billed_Cycle9LoadFileSel.txt'),
    ('EOC10', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC24"', var_Path, 'txGlobe_DP1_Billed_Cyc10LoadFileSel.txt'),
    ('EOC11', 'EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC27"', var_Path, 'txGlobe_DP1_Billed_Cyc11LoadFileSel.txt');
    /* Loop from the table */
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
    DROP TABLE IF EXISTS vartable$sp_mybss_globe_eoc_preload_export;
END;
$procedure$
