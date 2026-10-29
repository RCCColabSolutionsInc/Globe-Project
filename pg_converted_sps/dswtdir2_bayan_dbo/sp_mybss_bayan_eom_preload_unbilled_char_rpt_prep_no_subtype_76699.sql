CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_rpt_prep_no_subtype()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_unbilled_char_subtypemissing_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unbilled_char_subtypemissing_cache (missing_subtype)
    SELECT
        missing_subtype
        FROM dswtdir2_bayan_dbo.tvbayan_unbilled_char_column05_subtypemissingrptsel;
END;
$procedure$
