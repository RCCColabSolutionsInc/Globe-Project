CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_deferred_postload_report_prepare_postload_v()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.rpt_innove_php_deferred_postload_report_prepare_postload_valid_cache;
    INSERT INTO dswtdir1_dbo.rpt_innove_php_deferred_postload_report_prepare_postload_valid_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, sortorder, uniquekey, error, load_message)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, zdsp_order, zdsp_uniquekey, zerror, zload_message
        FROM dswtdir1_dbo.tvinnove_php_deferred_postload_valid_rptsel;
END;
$procedure$
