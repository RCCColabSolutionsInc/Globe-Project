CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unearned_msf_report_prepare_subtypem()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_subtypemissing_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_subtypemissing_cache (missing_subtype)
    SELECT
        missing_subtype
        FROM dswtdir2_bayan_dbo.tvbayan_unearned_msf_column05_subtypemissingrptsel;
END;
$procedure$
