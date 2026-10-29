CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_prod_serv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_prod_serv;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_prod_serv (mandt, zpl_st, product_group, service_type, customer_class, market_segment, revenue_type)
    SELECT
        mandt, zpl_st, product_group, service_type, customer_class, market_segment, revenue_type
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_prod_serv;
END;
$procedure$
