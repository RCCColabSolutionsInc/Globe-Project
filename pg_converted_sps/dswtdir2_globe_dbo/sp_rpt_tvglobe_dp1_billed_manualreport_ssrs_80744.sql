CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_manualreport_ssrs(IN par_cyclecode character varying, INOUT p_refcur refcursor)
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
    /* EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Manual_Report] @BCCode */
    OPEN p_refcur FOR
    SELECT
        zlegacydsp_order, data, "Posting Date", sapfigl, "Customer Type", "Subscriber Type", "Charge Code", "Discount Code", amount, hits, uom, brand, spa, "Rev Type", gl, spb, remarks
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_manualreport_cache
        WHERE LOWER(billcycle) = LOWER(var_BCCode)
        ORDER BY sequenceid NULLS FIRST;
END;
$procedure$
