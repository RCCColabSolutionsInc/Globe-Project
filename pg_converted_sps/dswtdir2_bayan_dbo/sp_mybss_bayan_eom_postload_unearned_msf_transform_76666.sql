CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_unearned_msf_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* Rules */
    CALL dswtdir2_bayan_dbo.trbayan_unearned_msf_zloaded_upd()
    /* Loaded Records */
    ;
END;
$procedure$
