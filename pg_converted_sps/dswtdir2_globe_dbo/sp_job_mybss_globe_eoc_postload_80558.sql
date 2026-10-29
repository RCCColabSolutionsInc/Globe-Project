CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_job_mybss_globe_eoc_postload(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 10, 2023 */
/* Description: Procedural MybssEOC processing */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Update ODBC */
    
    /*
    SET @procedureName  = '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_LoadOdbc]';
    SET @cmd  = 'EXEC ' + @procedureName;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] 'MyBSS','Globe','DP1 - Postload',@CycleCode,@procedureName,@cmd
    */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* DSP Migrate equivalent */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Prepare the report */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Export the report to excel file w/c will be attached to email notification later */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
END;
$procedure$
