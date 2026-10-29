CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_postload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'Memo';
    var_ProcessGroup VARCHAR(300) DEFAULT 'All';
    var_Step VARCHAR(300) DEFAULT 'Postload';
    var_Others VARCHAR(200) DEFAULT 'Daily';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
    var_JobNameSummary VARCHAR(200) DEFAULT 'Memo_Postload_P25_Notif_Summary_AdHoc';
BEGIN
    /* Reload SAP lookup data */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* TRANSFORM */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Prepate the reports - cache */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Call or execute an sql agent job that sends the summary of the processing in asyncronous manner */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobNameSummary;
    */
END;
$procedure$
