CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_000_loadsaptables_fixed()
 LANGUAGE plpgsql
AS $procedure$
BEGIN CALL dgs4hana_tdir1_dbo.sp_ztf0002s(); CALL dgs4hana_tdir1_dbo.sp_ztf0001s(); CALL dgs4hana_tdir1_dbo.sp_zffi_subtype(); CALL dgs4hana_tdir1_dbo.sp_zffi_0346(); END; $procedure$
