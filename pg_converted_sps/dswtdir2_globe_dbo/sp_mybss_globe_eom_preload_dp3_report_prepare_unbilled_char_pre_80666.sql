CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_pre()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, remark, zdsp_order, zdsp_uniquekey)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, remark, zdsp_order, zdsp_uniquekey
        FROM dswtdir2_globe_dbo.tvglobe_dp3_unbilled_char_preloadrptsel;
END;
$procedure$
