CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_loadsaptables_pg()
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 13, 2023 */
/* Description: */
/* ============================================= */

/* ============================================= */
/* Converted by	:	RCC-Arnel Martinez */
/* Create date	: August 13, 20263 */
/* Sample Rund	:	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_loadsaptables(); */
/* ============================================= */

BEGIN
    CALL dgs4hana_tdir1_dbo.sp_ztf0002s();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001s();
    CALL dgs4hana_tdir1_dbo.sp_zffi_subtype();
    CALL dgs4hana_tdir1_dbo.sp_zffi_0346();
END;
$procedure$
