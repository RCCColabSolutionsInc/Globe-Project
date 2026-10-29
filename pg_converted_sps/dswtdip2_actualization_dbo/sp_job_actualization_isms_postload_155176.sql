CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_job_actualization_isms_postload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 1. Load SAP tables */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_loadsaptables();
    /* 2. Transform */
    /* 3. Export */
    /* 4. Prepare report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_prepare();
    /* 5. Export the report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_export();
    /* 6. Send report */
    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_send();
END;
$procedure$
