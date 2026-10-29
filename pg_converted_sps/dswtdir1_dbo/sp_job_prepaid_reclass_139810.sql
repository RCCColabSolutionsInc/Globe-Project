CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_prepaid_reclass()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'Prepaid';
    var_ProcessGroup VARCHAR(300) DEFAULT 'All';
    var_Step VARCHAR(300) DEFAULT 'Prepaid - Reclass';
    var_Others VARCHAR(200) DEFAULT 'Every 3rd of the month';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
    var_JobName VARCHAR(200) DEFAULT 'Prepaid_Reclass_Preload_P15_SFTP_AdHoc';
BEGIN
    /* EXPORT Interface files */
    var_procedureName := '[dswTDIR1].[dbo].[sp_Prepaid_Reclass_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Call or execute an sql agent job that sends the summary of the processing in asyncronous manner */
    
    /*
    DECLARE @JobNameSummary NVARCHAR(200) = 'Prepaid_Reclass_P17_Notif_Summary_AdHoc'
    EXEC msdb.dbo.sp_start_job @JobNameSummary;
    */
    /* Call or execute sql agent job that uploads the exported file to SAP via SFTP */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
END;
$procedure$
