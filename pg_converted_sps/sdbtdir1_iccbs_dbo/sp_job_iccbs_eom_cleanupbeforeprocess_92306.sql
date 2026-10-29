CREATE OR REPLACE PROCEDURE sdbtdir1_iccbs_dbo.sp_job_iccbs_eom_cleanupbeforeprocess()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.bl_act_trans_ext_bt_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_bdef_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcb_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_blcu_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_falcon_billed_volvo_072020_for_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_falcon_billed_volvo_072020_oss_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_fdef_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_php_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcb_usd_ssis;
    TRUNCATE TABLE sdbtdir1_iccbs_dbo.sap_flcu_php_ssis;
    /* TRUNCATE TABLE [AA0850_ssis] */
    /* TRUNCATE TABLE [AA0861_ssis] */
    /* TRUNCATE TABLE [AA0891_ssis] */
    /* TRUNCATE TABLE [AA0892_ssis] */
    /* TRUNCATE TABLE [BP0940_ssis] */
    /* TRUNCATE TABLE [BP0970_ssis] */
    /* TRUNCATE TABLE [SAP_BDEF_ALL_ssis] */
    /* TRUNCATE TABLE [SAP_BLCB_ALL_ssis] */
    /* TRUNCATE TABLE [SAP_BLCB_PHP_mmdd_ssis] */
    /* TRUNCATE TABLE [SAP_BLCU_ALL_ssis] */
    /* TRUNCATE TABLE [SAP_BLCB_USD_mmdd_ssis] */
    /* TRUNCATE TABLE [SAP_FDEF_ALL_ssis] */
    /* TRUNCATE TABLE [SAP_FLCB_ALL_ssis] */
    /* TRUNCATE TABLE [SAP_FLCB_PHP_mmdd_ssis] */
    /* TRUNCATE TABLE [SAP_FLCB_USD_mmdd_ssis] */
    /* TRUNCATE TABLE [SAP_FLCU_ALL_ssis] */
END;
$procedure$
