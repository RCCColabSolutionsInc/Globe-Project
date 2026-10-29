CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_000_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Aug 2, 2023 */
/* Description: */
/* ============================================= */
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_subtype();
    CALL dgs4hana_tdir1_dbo.sp_zffi_0346();
END;
$procedure$
