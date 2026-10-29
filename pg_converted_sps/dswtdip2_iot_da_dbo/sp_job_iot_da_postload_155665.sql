CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_job_iot_da_postload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdip2_iot_da_dbo.sp_iot_da_postload_loadsaptables();
    /* NA EXEC [dbo].[sp_IOT_DA_Postload_Transform]; */
    CALL dswtdip2_iot_da_dbo.sp_iot_da_postload_report_prepare();
    CALL dswtdip2_iot_da_dbo.sp_iot_da_postload_report_export();
    CALL dswtdip2_iot_da_dbo.sp_iot_da_postload_report_send();
END;
$procedure$
