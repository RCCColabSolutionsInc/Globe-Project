CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unearned_msf_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 29, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* Rules */
    CALL dswtdir2_innove_dbo.trinnove_unearned_msf_zloaded_upd();
    /* Loaded Records */
    CALL dswtdir2_innove_dbo.trinnove_unearned_msf_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
END;
$procedure$
