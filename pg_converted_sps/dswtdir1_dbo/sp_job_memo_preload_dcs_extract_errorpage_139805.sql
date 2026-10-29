CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_preload_dcs_extract_errorpage()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Rules */
    CALL dswtdir1_dbo.trmemoapp_dcs_preload_preloaderror_insert_into_dcmemoapp_ins();
END;
$procedure$
