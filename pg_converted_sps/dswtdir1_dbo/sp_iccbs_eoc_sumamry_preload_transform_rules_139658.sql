CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_eoc_sumamry_preload_transform_rules()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trwireline_tot_delete_from_dcwireline_tot_del();
    /* Delete_From_dcWireline_TOT */
    CALL dswtdir1_dbo.trwireline_tot_insert_into_dcwireline_tot_ins()
    /* Insert_Into_dcWireline_TOT All records from ttWireline */
    ;
END;
$procedure$
