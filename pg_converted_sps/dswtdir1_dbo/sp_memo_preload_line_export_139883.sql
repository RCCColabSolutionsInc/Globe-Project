CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_PathWithTax VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIR1-MEMEOAPP_V2\\MEMOAPP_V2_New\\WithTax';
    var_PathNoTax VARCHAR(500) DEFAULT E'F:\\BOA\\Transform\\Export\\TDIR1-MEMEOAPP_V2\\MEMOAPP_V2_New\\NoTax';
    var_sqlQuery TEXT;
    var_path_current VARCHAR(200);
    var_fileName VARCHAR(200);
    cursor_file CURSOR FOR
    SELECT
        sqlquery, path, filename
        FROM vartable$sp_memo_preload_line_export;
BEGIN
    CREATE TEMPORARY TABLE vartable$sp_memo_preload_line_export
    (id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
        cyclecode VARCHAR(5),
        sqlquery TEXT,
        path VARCHAR(500),
        filename VARCHAR(200));
    /* Placeholder in the event that this data eventually comes from a maintenance table */
    INSERT INTO vartable$sp_memo_preload_line_export (sqlquery, path, filename)
    VALUES ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_01_Scn01_NoTax]', var_PathNoTax, 'OB_Scn1_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_02_Scn02To05_WithTax]', var_PathWithTax, 'OB_Scn2To5_WithTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_03_Scn02To5_NoTax]', var_PathNoTax, 'OB_Scn2To5_NoTax.txt'),
    /* ,('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_04_Scn06_Acc2To5A_Reversal]',@Path,'OB_Scn6_Acc2To5A_Rev.txt')  -- not in use */
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_05_Scn06_Acc2To5BNewAcc_NoTax]', var_PathNoTax, 'OB_Scn6_2To5B_NewAccDoc_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_06_Scn06_Acc2To5C_WithTax]', var_PathWithTax, 'OB_Scn6_Acc2To5C_Inv_WithTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_07_Scn06_Acc2To5C_NoTax]', var_PathNoTax, 'OB_Scn6_Acc2To5C_Inv_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_08_Scn08_M_NoTax]', var_PathNoTax, 'OB_Scn8M_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_09_Scn08_R_NoTax]', var_PathNoTax, 'OB_Scn8R_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_10_Scn09_NoTax]', var_PathNoTax, 'OB_Scn9_NoTax.txt'),
    ('EXEC [dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export_11_Scn10_NoTax]', var_PathNoTax, 'OB_Scn10_NoTax.txt');
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
    DROP TABLE IF EXISTS vartable$sp_memo_preload_line_export;
END;
$procedure$
