CREATE OR REPLACE PROCEDURE sdbtdir2_innove_dbo.sp_job_mybss_innove_eom_cleanupbeforeprocess_03()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir2_innove_dbo."307_Unbilled_Adjustments_Report_I";
    TRUNCATE TABLE sdbtdir2_innove_dbo."317_Unbilled_Charges_I";
    TRUNCATE TABLE sdbtdir2_innove_dbo."324_Unearned_MSF_Summary_Report_I";
    TRUNCATE TABLE sdbtdir2_innove_dbo.sap_airc_i;
    TRUNCATE TABLE sdbtdir2_innove_dbo.sap_aiuc_i;
    TRUNCATE TABLE sdbtdir2_innove_dbo.sap_glunbilled_i;
    TRUNCATE TABLE sdbtdir2_innove_dbo.sap_glunbilled_unconf_i;
    TRUNCATE TABLE dswtdir2_innove_dbo.ttinnove_unearned_msf;
    TRUNCATE TABLE dswtdir2_innove_dbo.ttinnove_unbilled_char;
    TRUNCATE TABLE dswtdir2_innove_dbo.ttinnove_unbilled_adj;
END;
$procedure$
