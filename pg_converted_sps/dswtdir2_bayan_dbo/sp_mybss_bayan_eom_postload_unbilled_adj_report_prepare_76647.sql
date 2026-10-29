CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_adj_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_adj_error();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_adj_valid();
END;
$procedure$
