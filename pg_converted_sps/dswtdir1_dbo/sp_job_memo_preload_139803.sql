CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_preload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'Memo';
    var_ProcessGroup VARCHAR(300) DEFAULT 'All';
    var_Step VARCHAR(300) DEFAULT 'Preload';
    var_Others VARCHAR(200) DEFAULT 'Daily';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
    var_JobName VARCHAR(200) DEFAULT 'Memo_Preload_P15_SFTP_AdHoc';
    var_JobNameSummary VARCHAR(200) DEFAULT 'Memo_Preload_P17_Notif_Summary_AdHoc';
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    /* Reload SAP lookup data */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Scenario_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* TRANSFORM */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Scenario_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Remediate */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Remediation]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* EXPORT Interface files */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Prepate the reports - cache */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Call or execute sql agent job that uploads the exported file to SAP via SFTP */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
    /* Call or execute an sql agent job that sends the summary of the processing in asyncronous manner */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobNameSummary;
    */
END;
$procedure$
