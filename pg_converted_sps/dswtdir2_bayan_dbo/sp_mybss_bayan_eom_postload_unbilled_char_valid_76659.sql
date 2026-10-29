CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_char_valid()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_postload_report_unbilled_char_valid_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_unbilled_char_valid_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, posting_log_message)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_bayan_dbo.tvbayan_unbilled_char_postload_validrptsel;
END;
$procedure$
