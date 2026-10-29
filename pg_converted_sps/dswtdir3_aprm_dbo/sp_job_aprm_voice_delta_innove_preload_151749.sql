CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_delta_innove_preload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'APRM Voice';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Innove';
    var_Step VARCHAR(300) DEFAULT 'Delta - Preload';
    var_Others VARCHAR(200) DEFAULT 'Second Cycle';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    /* Reload SAP lookup data */
    /*
    SET @procedureName  = '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOC_Preload_LoadSapTables]';
    SET @cmd  = 'EXEC ' + @procedureName;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] 'MyBSS','Globe','DP1_Billed - Preload',@CycleCode,@procedureName,@cmd
    */
    /* TRANSFORM */
    /* No transformation logic */
    
    /*
    SET @procedureName  = '[dswTDIR3_APRM].[dbo].[sp_MyBSS_Globe_EOM_Preload_DP2_Transform]';
    SET @cmd  = 'EXEC ' + @procedureName;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] @Proccess,@ProcessGroup,@Step,@Others,@procedureName,@cmd
    */
    
    /* EXPORT Interface files */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Delta_Innove_Preload_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Prepate the reports - cache */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Delta_Innove_Preload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Delta_Innove_Preload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Delta_Innove_Preload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* SFTP */
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job N'APRM_VoiceI_Innove_P15_Preload_SFTP_Send_AdHoc';
    */
END;
$procedure$
