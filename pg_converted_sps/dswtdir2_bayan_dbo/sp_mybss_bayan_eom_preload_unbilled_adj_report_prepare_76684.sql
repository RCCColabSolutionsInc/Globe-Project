CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare()
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare_subtypemissing();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare_chargecodemissing();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare_preload();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_prepare_varianceintotalamount();
END;
$procedure$
