CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp3_report_prepare_unbilled_char_er()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Dependencies: ODBC */
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, remark, zdsp_order, zdsp_uniquekey, posting_log_message)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, remark, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_globe_dbo.tvglobe_dp3_unbilled_char_postload_errorrptsel;
END;
$procedure$
