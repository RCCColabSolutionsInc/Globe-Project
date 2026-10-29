CREATE OR REPLACE PROCEDURE sdbtdir2_globe_dbo.sp_job_mybss_globe_eoc_cleanupbeforeprocess_12()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIR2_Globe */
BEGIN
    TRUNCATE TABLE sdbtdir2_globe_dbo."411_Bill_Control_ssis";
    TRUNCATE TABLE sdbtdir2_globe_dbo.sapglbilled_ssis;
    TRUNCATE TABLE sdbtdir2_globe_dbo."318_Billed_Charges_ssis";
    TRUNCATE TABLE sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis";
    TRUNCATE TABLE dswtdir2_globe_dbo.stglobe_dp1_billed_tdir2_globe_saplbilled;
    TRUNCATE TABLE dswtdir2_globe_dbo.ttglobe_dp1_billed;
END;
$procedure$
