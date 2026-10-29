CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_000_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
/* Author:		Winston Madiano */
/* Create date: August 2, 2023 */
/* ============================================= */
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta();
END;
$procedure$
