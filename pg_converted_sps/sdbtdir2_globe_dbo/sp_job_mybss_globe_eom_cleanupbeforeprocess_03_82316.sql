CREATE OR REPLACE PROCEDURE sdbtdir2_globe_dbo.sp_job_mybss_globe_eom_cleanupbeforeprocess_03()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIR2_Globe */
BEGIN
    TRUNCATE TABLE sdbtdir2_globe_dbo."307_Unbilled_Adjustments_Report_G";
    TRUNCATE TABLE sdbtdir2_globe_dbo."307_Unbilled_Adjustments_Report_G_header";
    TRUNCATE TABLE sdbtdir2_globe_dbo."317_Unbilled_Charges_Summary_Report_G";
    TRUNCATE TABLE sdbtdir2_globe_dbo."324_Unearned_MSF";
    TRUNCATE TABLE sdbtdir2_globe_dbo.dp5_unconfirmed_advance_msf_header;
    TRUNCATE TABLE sdbtdir2_globe_dbo.sap_airc;
    TRUNCATE TABLE sdbtdir2_globe_dbo.sap_aiuc_g;
    TRUNCATE TABLE sdbtdir2_globe_dbo.sap_glunbilled_g;
    TRUNCATE TABLE sdbtdir2_globe_dbo.sap_glunbilled_unconf_g;
    TRUNCATE TABLE sdbtdir2_globe_dbo.unconfirmed_advanced_msf_charges;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp2_unearned;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp3_unbilled_char;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp4_unbilled_adj;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp5_unconfirmed;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp5_unconfirmed_adj;
END;
$procedure$
