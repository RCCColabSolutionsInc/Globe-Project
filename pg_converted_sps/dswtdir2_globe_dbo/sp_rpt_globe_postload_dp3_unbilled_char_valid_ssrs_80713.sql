CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_postload_dp3_unbilled_char_valid_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, remark, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache;
END;
$procedure$
