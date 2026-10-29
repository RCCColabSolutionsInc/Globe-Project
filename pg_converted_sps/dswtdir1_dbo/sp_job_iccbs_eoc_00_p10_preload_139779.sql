CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_eoc_00_p10_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    RAISE NOTICE 'TODO';
    /* 1. sp_ICCBS_EOC_00_Preload_LoadSapTables */
    /* 2. sp_ICCBS_EOC_GT_Preload_Transform */
    /* 3. sp_ICCBS_EOC_BT_Preload_Transform */
    /* 4. sp_ICCBS_EOC_Summary_Preload_Transform */
    CALL dswtdir1_dbo.sp_iccbs_eoc_gt_preload_transform();
    CALL dswtdir1_dbo.sp_iccbs_eoc_bt_preload_transform();
    CALL dswtdir1_dbo.sp_iccbs_eoc_summary_preload_transform();
END;
$procedure$
