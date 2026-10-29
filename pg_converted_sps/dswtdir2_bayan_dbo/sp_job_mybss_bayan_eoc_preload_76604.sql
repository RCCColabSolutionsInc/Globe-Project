CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_job_mybss_bayan_eoc_preload(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 9, 2023 */
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
    var_JobName VARCHAR(200) DEFAULT 'MyBSS_Bayan_EOC' || var_Formatted || '_P15_Preload_SFTP_AdHoc';
BEGIN
    /* Reload SAP lookup tables */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* TRANSFORM */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_Transform]';
    /* SET @cmd  = 'EXEC ' + @procedureName; */
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* EXPORT Interface files */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Prepare the reports - cache */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Export the data to an excel file that will be sent as attachment in the later process */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Bayan', 'Billed - Preload', par_CycleCode, var_procedureName, var_cmd);
    /* TODO: Send to SAP - c/o boss Norman */
    /*
    SET @procedureName  = '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOC_Preload_SFTP]';
    SET @cmd  = 'EXEC ' + @procedureName + ' ' + @CycleCode;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] 'MyBSS','Bayan','Billed - Preload',@CycleCode,@procedureName,@cmd\
    */
    /* More efficient sftp sending */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
END;
$procedure$
