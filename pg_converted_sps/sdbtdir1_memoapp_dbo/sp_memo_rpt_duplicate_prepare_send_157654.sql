CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memo_rpt_duplicate_prepare_send()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL sdbtdir1_memoapp_dbo.sp_memorfp_job_getremoveduplicates();
    CALL sdbtdir1_memoapp_dbo.sp_memo_rpt_checkduplicate_prepare();
    CALL sdbtdir1_memoapp_dbo.sp_memo_rpt_checkduplicate_send();
END;
$procedure$
