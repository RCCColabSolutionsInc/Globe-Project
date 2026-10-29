CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_preload_dcs()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'Memo';
    var_ProcessGroup VARCHAR(300) DEFAULT 'All';
    var_Step VARCHAR(300) DEFAULT 'Preload - DCS';
    var_Others VARCHAR(200) DEFAULT 'Daily';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
    var_JobName VARCHAR(200) DEFAULT 'Memo_Preload_DCS_P15_SFTP_AdHoc';
BEGIN
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Call or execute sql agent job that uploads the exported file to SAP via SFTP */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
END;
$procedure$
