CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_validation()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_validation_cache;
    INSERT INTO dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_validation_cache (source, "Column Name", "RECORD VALUE", "Validation Message")
    SELECT
        source, "Column Name", "RECORD VALUE", "Validation Message"
        FROM dswtdip2_actualization_dbo.tvactualization_isms_validation_rptsel;
END;
$procedure$
