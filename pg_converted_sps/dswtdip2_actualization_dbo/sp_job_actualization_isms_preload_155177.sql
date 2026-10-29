CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_job_actualization_isms_preload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_JobName VARCHAR(200) DEFAULT 'Ph2_ISMS_Actualization_P15_Preload_SFTP_AdHoc';
BEGIN
    /* 1. Load SAP tables */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_loadsaptables();
    /* 2. Transform */
    /* 3. Export */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_export();
    /* 4. Prepare report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare();
    /* 5. Export the report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_export();
    /* 6. Send report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_send();
    /* 7. Sftp export */
    
    /* Call or execute sql agent job that uploads the exported file to SAP via SFTP */
    
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
END;
$procedure$
