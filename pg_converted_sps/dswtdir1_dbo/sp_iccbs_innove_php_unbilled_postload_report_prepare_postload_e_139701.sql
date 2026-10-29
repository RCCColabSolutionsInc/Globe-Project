CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_unbilled_postload_report_prepare_postload_e()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.rpt_innove_php_unbilled_postload_report_prepare_postload_error_cache;
    INSERT INTO dswtdir1_dbo.rpt_innove_php_unbilled_postload_report_prepare_postload_error_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, sortorder, uniquekey, error, loadmessage)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey, zerror, zload_message
        FROM dswtdir1_dbo.tvinnove_php_unbilled_postload_error_rptsel;
END;
$procedure$
