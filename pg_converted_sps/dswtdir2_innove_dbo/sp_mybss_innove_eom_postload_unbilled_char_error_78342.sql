CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unbilled_char_error()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_postload_report_unbilled_char_error_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_postload_report_unbilled_char_error_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, posting_log_message)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_innove_dbo.tvinnove_unbilled_char_postload_errorrptsel;
END;
$procedure$
