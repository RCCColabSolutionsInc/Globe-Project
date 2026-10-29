CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_loadsaptables_pg()
 LANGUAGE plpgsql
AS $procedure$

/* Author:		Winston Madiano */
/* Create date: Feb 13, 2023 */
/* ============================================= */
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    ---CALL DGS4HANA_TDIR1_DBO.SP_ZFFI_REPORT_ODBC_DELTA ();
END;
$procedure$
