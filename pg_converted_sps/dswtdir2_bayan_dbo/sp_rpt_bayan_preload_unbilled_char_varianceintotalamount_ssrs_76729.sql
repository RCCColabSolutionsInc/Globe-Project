CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_bayan_preload_unbilled_char_varianceintotalamount_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_bayan_dbo.rpt_preload_report_unbilled_char_varianceintotalamount_cache;
END;
$procedure$
