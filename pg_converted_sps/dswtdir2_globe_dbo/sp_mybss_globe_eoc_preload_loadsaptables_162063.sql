CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
/* Author:		Winston Madiano */
/* Create date: Feb 13, 2023 */
/* ============================================= */
	BEGIN

    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta();

	END;
$procedure$
