CREATE OR REPLACE PROCEDURE sdbtdir2_innove_dbo.sp_job_mybss_innove_eoc_cleanupbeforeprocess_12()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir2_innove_dbo."308_Billed_Adjustments_ssis";
    TRUNCATE TABLE sdbtdir2_innove_dbo."318_Billed_Charges_ssis";
    TRUNCATE TABLE sdbtdir2_innove_dbo."411_Bill_Control_PHP_ssis";
    TRUNCATE TABLE sdbtdir2_innove_dbo."411_Bill_Control_USD_ssis";
    TRUNCATE TABLE sdbtdir2_innove_dbo.sap_glbilled_ssis;
    TRUNCATE TABLE dswtdir2_innove_dbo.stinnove_billed_tdir2_innove_sapglbilled;
    TRUNCATE TABLE dswtdir2_innove_dbo.ttinnove_billed;
END;
$procedure$
