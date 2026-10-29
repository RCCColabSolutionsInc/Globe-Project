CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 29, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_subtypemissing();
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_chargecodemissing();
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_preload();
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_varianceintotalamount();
END;
$procedure$
