CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_control_recon_ssrs(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_BCCode VARCHAR(5);
BEGIN
    /* = 'BC01'; */
    SELECT
        billcycle
        INTO var_BCCode
        FROM dswtdir2_globe_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_cycleCode);
    --OPEN p_refcur FOR
    SELECT
        sort, column1, column2, column3, column4, column5, column6, column7
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_control_recon_cache
        WHERE LOWER(billcycle) = LOWER(var_BCCode)
        ORDER BY billcycle NULLS FIRST, sort NULLS FIRST;
    /* EXEC [dbo].sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Control_Recon @BCCode */
END;
$procedure$
