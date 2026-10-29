CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_deferred_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.sp_iccbs_bayan_php_deferred_postload_report_prepare_postload_error();
    CALL dswtdir1_dbo.sp_iccbs_bayan_php_deferred_postload_report_prepare_postload_valid();
END;
$procedure$
