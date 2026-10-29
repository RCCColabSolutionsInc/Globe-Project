CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_innove_preload_unearned_msf_varianceintotalamount_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_varianceintotalamount_cache;
END;
$procedure$
