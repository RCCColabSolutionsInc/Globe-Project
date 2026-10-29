CREATE OR REPLACE PROCEDURE sdbtdir1_iccbs_dbo.sp_job_iccbs_eoc_cleanupbeforeprocess()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    TRUNCATE TABLE [bl_act_trans_ext_BT_ssis]
    TRUNCATE TABLE [sap_bdef_PHP_ssis]
    TRUNCATE TABLE [sap_bdef_USD_ssis]
    TRUNCATE TABLE [sap_blcb_PHP_ssis]
    TRUNCATE TABLE [sap_blcb_USD_ssis]
    TRUNCATE TABLE [sap_blcu_PHP_ssis]
    TRUNCATE TABLE [sap_falcon_billed_volvo_072020_for_ssis]
    TRUNCATE TABLE [sap_falcon_billed_volvo_072020_oss_ssis]
    TRUNCATE TABLE [sap_fdef_PHP_ssis]
    TRUNCATE TABLE [sap_fdef_USD_ssis]
    TRUNCATE TABLE [sap_flcb_PHP_ssis]
    TRUNCATE TABLE [sap_flcb_USD_ssis]
    TRUNCATE TABLE [sap_flcu_PHP_ssis]
    */
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0850_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0861_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0891_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.aa0892_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bp0940_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bp0970_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_php_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcu_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_usd_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_all_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_php_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_usd_mmdd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcu_all_ssis;
END;
$procedure$
