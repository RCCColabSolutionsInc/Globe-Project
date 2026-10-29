CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_unbilled_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.sp_iccbs_bayan_php_unbilled_preload_report_prepare_preload();
END;
$procedure$
