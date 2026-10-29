CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp3_unbilled_char_manual_agg_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        ct, st, charge_code, sum_of_amount, "Unbilled charges", diff, tax_rate, net_of_tax, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache
        ORDER BY 1 NULLS FIRST, 2 NULLS FIRST, 3 NULLS FIRST;
END;
$procedure$
