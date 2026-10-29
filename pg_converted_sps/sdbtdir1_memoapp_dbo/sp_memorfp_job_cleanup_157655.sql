CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_job_cleanup()
 LANGUAGE plpgsql
AS $procedure$
/* #region sp_MemoRFP_Job_Cleanup */
BEGIN
    TRUNCATE TABLE sdbtdir1_memoapp_dbo.paymentrequests_38cols_ssis;
END;
$procedure$
