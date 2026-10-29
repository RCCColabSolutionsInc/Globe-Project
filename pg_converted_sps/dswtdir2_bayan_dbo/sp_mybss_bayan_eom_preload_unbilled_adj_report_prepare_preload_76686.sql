CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_unbilled_adj_preload_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unbilled_adj_preload_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, zdsp_order, zdsp_uniquekey)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, zdsp_order, zdsp_uniquekey
        FROM dswtdir2_bayan_dbo.tvbayan_unbilled_adj_preloadrptsel;
END;
$procedure$
