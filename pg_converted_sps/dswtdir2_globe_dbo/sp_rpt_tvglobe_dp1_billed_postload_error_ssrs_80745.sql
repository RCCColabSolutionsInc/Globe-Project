CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_postload_error_ssrs(IN par_cyclecode character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_BCCode VARCHAR(5) DEFAULT 'BC01';
BEGIN
    SELECT
        billcycle
        INTO var_BCCode
        FROM dswtdir2_globe_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
    /* EXEC [dbo].[sp_MyBSS_Globe_EOC_Postload_Report_DP1_Billed_Error] @BCCode */
    OPEN p_refcur FOR
    SELECT
        data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", "Discount Code", amount, hits, uom, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache
        WHERE LOWER(billcycle) = LOWER(var_BCCode)
        ORDER BY data NULLS FIRST, zdsp_order NULLS FIRST;
END;
$procedure$
