CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp2_unearned_manual_report_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        ct, st, "Charge Code", amount, umsf, diff, spa, rev_type, gl, spb, remarks
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache;
END;
$procedure$
