CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_000_loadsaptables_pg()
 LANGUAGE plpgsql
AS $procedure$
/* Author:		Winston Madiano */
/* Create date: Aug 2, 2023 */
/* ============================================= */
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta_pg();
END;
$procedure$
