CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_postload_dp2_unearned_valid_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache
        ORDER BY 1 NULLS FIRST;
END;
$procedure$
