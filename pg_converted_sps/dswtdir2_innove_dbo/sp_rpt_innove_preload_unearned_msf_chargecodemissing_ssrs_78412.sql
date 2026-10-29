CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_innove_preload_unearned_msf_chargecodemissing_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        missing_charge_code
        FROM dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_chargecodemissing_cache
        ORDER BY 1 NULLS FIRST;
END;
$procedure$
