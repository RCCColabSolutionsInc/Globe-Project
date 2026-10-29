CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 14, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges (zrownumber, "Customer Type", "Service Type", "Revenue Type", "Charge Code", "Offer ID", "Offer Description", "Charge Type", amount)
    SELECT
        zrownumber AS zrownumber, "Customer Type", "Service Type", "Revenue Type", "Charge Code", "Offer ID", "Offer Description", "Charge Type", amount
        FROM sdbtdir2_globe_dbo.unconfirmed_advanced_msf_charges
        ORDER BY zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zlegacydsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zdsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zpostingdateupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zspaupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zrev_typeupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zgl_zspbupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zamount_netupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zremarkupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zactiveupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_zbrandupd();
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_chargesdel();
    /* Target Delete by Source */
    CALL dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_chargesins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_globe_dbo.trglobe_dp5_unconfirmed_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
END;
$procedure$
