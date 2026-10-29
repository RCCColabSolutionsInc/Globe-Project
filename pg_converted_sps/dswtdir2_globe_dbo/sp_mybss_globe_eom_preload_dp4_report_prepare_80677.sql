CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 9, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare_unbilled_adj_manual();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare_unbilled_adj_agg_preload();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare_unbilled_adj_recon_amount();
END;
$procedure$
