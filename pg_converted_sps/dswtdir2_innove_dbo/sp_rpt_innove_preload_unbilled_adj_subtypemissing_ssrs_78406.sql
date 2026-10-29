CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_innove_preload_unbilled_adj_subtypemissing_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        missing_subtype
        FROM dswtdir2_innove_dbo.rpt_preload_report_unbilled_adj_subtypemissing_cache
        ORDER BY 1 NULLS FIRST;
END;
$procedure$
