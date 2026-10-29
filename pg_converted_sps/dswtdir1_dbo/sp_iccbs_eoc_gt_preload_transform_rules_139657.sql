CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_eoc_gt_preload_transform_rules()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trwireline_gt_delete_from_dcwireline_gt_del();
    /* Delete_From_dcWireline_GT */
    CALL dswtdir1_dbo.trwireline_gt_insert_into_dcwireline_gt_ins()
    /* Insert_Into_dcWireline_GT All records from ttWireline_GT */
    ;
END;
$procedure$
