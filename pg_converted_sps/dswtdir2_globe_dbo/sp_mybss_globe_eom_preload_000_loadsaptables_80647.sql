CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_000_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: August 2, 2023 */
/* Description: */
/* ============================================= */
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zfco_udt_map();
    CALL dgs4hana_tdir1_dbo.sp_ztf0188s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_ubadj_sbp();
END;
$procedure$
