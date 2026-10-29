CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_char_report_prepare_pg()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 23, 2023 */
/* Description: Report */
/* ============================================= */
BEGIN
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_char_error();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unbilled_char_valid();
END;
$procedure$
