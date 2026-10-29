CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_report_prepare_subtype()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unbilled_adj_subtypemissing_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unbilled_adj_subtypemissing_cache (missing_subtype)
    SELECT
        missing_subtype
        FROM dswtdir2_innove_dbo.tvinnove_unbilled_adj_column05_subtypemissingrptsel;
END;
$procedure$
