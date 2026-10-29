CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_accrual_innove_postload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'APRM Voice';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Innove';
    var_Step VARCHAR(300) DEFAULT 'Accrual - Postload';
    var_Others VARCHAR(200) DEFAULT 'First Cycle';
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
    /* Not export file */
    
    /*
    SET @procedureName  = '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Accrual_Bayan_Preload_Export]';
    SET @cmd  = 'EXEC ' + @procedureName;
    EXECUTE [etl_db].[dbo].[sp_ExecuteQueryAndLog] @Proccess,@ProcessGroup,@Step,@Others,@procedureName,@cmd
    */
    
    /* Prepate the reports - cache */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Accrual_Innove_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Accrual_Innove_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Accrual_Innove_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* TODO: Send to SAP - c/o boss Norman */
END;
$procedure$
