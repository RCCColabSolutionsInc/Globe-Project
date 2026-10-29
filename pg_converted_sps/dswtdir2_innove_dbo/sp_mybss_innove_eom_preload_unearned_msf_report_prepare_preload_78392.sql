CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_preload_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_preload_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey)
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey
        FROM dswtdir2_innove_dbo.tvinnove_unearned_msf_preloadrptsel;
END;
$procedure$
