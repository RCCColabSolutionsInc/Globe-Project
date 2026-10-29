CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_eoc_summary_preload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.sp_iccbs_eoc_summary_preload_transform_loadsource();
    CALL dswtdir1_dbo.sp_iccbs_eoc_sumamry_preload_transform_rules();
END;
$procedure$
