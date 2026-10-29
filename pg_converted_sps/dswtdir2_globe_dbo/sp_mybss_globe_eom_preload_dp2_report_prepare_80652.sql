CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 21, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_manual_report();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_preload();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_recon_amount();
END;
$procedure$
