CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_cust_serv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_cust_serv;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_cust_serv (mandt, customer_account, service_type)
    SELECT
        mandt, customer_account, service_type
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_cust_serv;
END;
$procedure$
