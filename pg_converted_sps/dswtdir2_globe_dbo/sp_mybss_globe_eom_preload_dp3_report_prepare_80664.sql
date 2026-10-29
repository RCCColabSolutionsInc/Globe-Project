CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 8, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_manual_agg();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_preload();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_recon_amount();
END;
$procedure$
