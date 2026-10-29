CREATE OR REPLACE PROCEDURE sdbtdir2_bayan_dbo.sp_job_mybss_bayan_eom_cleanupbeforeprocess_03()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir2_bayan_dbo."307_Unbilled_Adjustments_Report_B";
    TRUNCATE TABLE sdbtdir2_bayan_dbo."317_Unbilled_Charges_B";
    TRUNCATE TABLE sdbtdir2_bayan_dbo."324_Unearned_MSF_Summary_Report_B";
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_airc_b;
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_airc_unconf_b;
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_aiuc_b;
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_aiuc_unconf_b;
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_glunbilled_b;
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_glunbilled_unconf_b;
    TRUNCATE TABLE dswtdir2_bayan_dbo.ttbayan_unearned_msf;
    TRUNCATE TABLE dswtdir2_bayan_dbo.ttbayan_unbilled_char;
    TRUNCATE TABLE dswtdir2_bayan_dbo.ttbayan_unbilled_adj;
END;
$procedure$
