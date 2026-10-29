CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_unbilled_preload_report_prepare_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.rpt_bayan_php_unbilled_preload_report_prepare_preload_cache;
    INSERT INTO dswtdir1_dbo.rpt_bayan_php_unbilled_preload_report_prepare_preload_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey, zerror)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey, zerror
        FROM dswtdir1_dbo.tvbayan_php_unbilled_preload_rptsel;
END;
$procedure$
