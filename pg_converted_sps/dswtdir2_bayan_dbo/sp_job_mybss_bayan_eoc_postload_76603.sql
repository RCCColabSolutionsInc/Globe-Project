CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_job_mybss_bayan_eoc_postload(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 9 2023 */
/* Description: Procedural MybssEOC processing */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Update ODBC */
    
    /*
    SET @procedureName  = '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_LoadOdbc]';
    SET @cmd  = 'EXEC ' + @procedureName;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] 'MyBSS','Bayan','DP1 - Postload',@CycleCode,@procedureName,@cmd
    */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* dsp migrate orig place */
    /* DSP Migrate equivalent */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Prepare the report */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Export data excel files. to be sent out as an email attachment later */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Send the report */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
END;
$procedure$
