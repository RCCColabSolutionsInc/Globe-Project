CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_report_prepare_chargec()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unbilled_adj_chargecodemissing_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unbilled_adj_chargecodemissing_cache (missing_charge_code)
    SELECT
        missing_charge_code
        FROM dswtdir2_innove_dbo.tvinnove_unbilled_adj_column06_chargecodemissingrptsel;
END;
$procedure$
