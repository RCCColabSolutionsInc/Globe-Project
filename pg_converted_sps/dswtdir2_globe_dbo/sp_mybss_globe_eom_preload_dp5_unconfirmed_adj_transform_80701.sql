CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 15, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g (zrownumber, column1, column2, column3, column4, column5, column6, column7)
    SELECT
        zrownumber, column1, column2, column3, column4, column5, column6, column7
        FROM sdbtdir2_globe_dbo.sap_glunbilled_unconf_g
        ORDER BY zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zlegacydsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zdsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zpostingdateupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zspaupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zrev_typeupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zgl_zspbupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zgl2upd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_ztaxupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zamount_netupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zremarkupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zbrandupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_zactiveupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_gdel();
    /* Target Delete by Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_gins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_globe_dbo.trglobe_dp5_unconfirmed_adj_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
END;
$procedure$
