CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unearned_msf_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 29, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unearned_msf_error();
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unearned_msf_valid();
END;
$procedure$
