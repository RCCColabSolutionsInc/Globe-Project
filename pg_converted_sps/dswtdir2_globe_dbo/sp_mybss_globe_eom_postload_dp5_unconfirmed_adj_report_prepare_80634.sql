CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_unconfirmed_adj_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 14, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_report_prepare_unconfirmed_adj_error();
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_report_prepare_unconfirmed_adj_valid();
END;
$procedure$
