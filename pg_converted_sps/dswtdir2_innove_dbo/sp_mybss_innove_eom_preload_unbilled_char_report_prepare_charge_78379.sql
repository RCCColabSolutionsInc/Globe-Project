CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_report_prepare_charge()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unbilled_char_chargecodemissing_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unbilled_char_chargecodemissing_cache (missing_charge_code)
    SELECT
        missing_charge_code
        FROM dswtdir2_innove_dbo.tvinnove_unbilled_char_column06_chargecodemissingrptsel;
END;
$procedure$
