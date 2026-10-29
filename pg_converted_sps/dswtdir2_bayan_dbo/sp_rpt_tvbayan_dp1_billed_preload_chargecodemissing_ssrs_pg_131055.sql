CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_chargecodemissing_ssrs_pg(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    OPEN p_refcur FOR
    SELECT
        missing_charge_code
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
        ORDER BY 1 NULLS FIRST;
END;
$procedure$
