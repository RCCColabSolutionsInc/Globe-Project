CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_tvinnove_dp1_billed_preload_subscriber_ssrs_pg(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    OPEN p_refcur FOR
    SELECT
        "subscriber_type"
        FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_cache
        ORDER BY 1 NULLS FIRST;
END;
$procedure$
