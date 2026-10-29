CREATE OR REPLACE PROCEDURE sdbtdir2_bayan_dbo.sp_job_mybss_bayan_eoc_cleanupbeforeprocess_12()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir2_bayan_dbo."308_Billed_Adjustments_ssis";
    TRUNCATE TABLE sdbtdir2_bayan_dbo."411_Bill_Control_PHP_ssis";
    TRUNCATE TABLE sdbtdir2_bayan_dbo."411_Bill_Control_USD_ssis";
    TRUNCATE TABLE sdbtdir2_bayan_dbo.sap_glbilled_ssis;
    TRUNCATE TABLE sdbtdir2_bayan_dbo."318_Billed_Charges_ssis";
    TRUNCATE TABLE dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled;
    TRUNCATE TABLE dswtdir2_bayan_dbo.ttbayan_billed;
END;
$procedure$
