CREATE OR REPLACE PROCEDURE sdbtdip2_iot_da_dbo.sp_job_iot_da_p01_setup_cleanup()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdip2_iot_da_dbo.detailstapin_ssis;
    TRUNCATE TABLE sdbtdip2_iot_da_dbo.detailstapout_ssis;
END;
$procedure$
