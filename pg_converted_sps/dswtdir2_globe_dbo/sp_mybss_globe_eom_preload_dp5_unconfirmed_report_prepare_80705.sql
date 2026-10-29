CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 14, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_report_prepare_unconfirmed_advanced_msf_charges_manual();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_report_prepare_unconfirmed_charges_agg();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_report_prepare_unconfirmed_msf_agg();
END;
$procedure$
