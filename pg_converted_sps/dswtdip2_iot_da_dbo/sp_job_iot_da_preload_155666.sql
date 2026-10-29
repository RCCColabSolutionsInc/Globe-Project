CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_job_iot_da_preload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_JobName VARCHAR(200) DEFAULT 'IOT_DA_Preload_SFTP_AdHoc';
BEGIN
    /* EXEC [dbo].[sp_IOT_DA_LoadSapTables] -- TODO */
    CALL dswtdip2_iot_da_dbo.sp_iot_da_transform();
    CALL dswtdip2_iot_da_dbo.sp_iot_da_export();
    CALL dswtdip2_iot_da_dbo.sp_iot_da_report_prepare();
    /* TODO */
    CALL dswtdip2_iot_da_dbo.sp_iot_da_report_export();
    /* TODO */
    CALL dswtdip2_iot_da_dbo.sp_iot_da_report_send();
    /* Call or execute sql agent job that uploads the exported file to SAP via SFTP */
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @JobName
    */
    /* TODO */
END;
$procedure$
