CREATE OR REPLACE PROCEDURE sdbtdir1_iccbs_dbo.sp_job_iccbs_cleanupbeforeprocess()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0850_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0861_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0891_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0892_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bl_act_trans_ext_bt_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bp0940_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bp0970_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_php_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_usd_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcu_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcu_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_falcon_billed_volvo_072020_for_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_falcon_billed_volvo_072020_oss_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_php_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_usd_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcu_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcu_php_ssis;
END;
$procedure$
