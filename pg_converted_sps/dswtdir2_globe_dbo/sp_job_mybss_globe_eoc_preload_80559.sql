CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_job_mybss_globe_eoc_preload(IN par_cyclecode character varying)
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
    var_Formatted VARCHAR(200)
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    = FORMAT(CAST(REPLACE(@CycleCode, 'EOC', '') AS INT), '00')
    */;
    var_JobName VARCHAR(200) DEFAULT 'MyBSS_Globe_EOC' || var_Formatted || '_P15_Preload_SFTP_AdHoc';
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    /* LOAD data from Text file(Execute SSIS) */
    /*
    EXEC [etl_db].[dbo].[sp_logger] 'MyBSS Globe EOC','Start: sp_MyBSS_Globe_EOC_Preload_LoadFiles','Extracting files from sources..',NULL,NULL
    EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_LoadFiles]
    EXEC [etl_db].[dbo].[sp_logger] 'MyBSgS Globe EOC','End: sp_MyBSS_Globe_EOC_Preload_LoadFiles','Done extracting files. ',NULL,NULL
    */
    /* Reload SAP lookup data */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* TRANSFORM */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_Transform]';
    /* SET @cmd  = 'EXEC ' + @procedureName; */
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* EXPORT Interface files */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Prepate the reports - cache tables */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Export the report into an excel files */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Send the reports via attachments through email */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Globe', 'DP1_Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* SFTP Send to SAP - c/o boss Norman */
    /*
    SET @procedureName  = '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_SFTP]';
    SET @cmd  = 'EXEC ' + @procedureName + ' ' + @CycleCode;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] 'MyBSS','Globe','DP1_Billed - Preload',@CycleCode,@procedureName,@cmd
    */
    /* More efficient */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
END;
$procedure$
