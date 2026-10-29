CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_cust_mktseg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_cust_mktseg;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_cust_mktseg (mandt, zfn_cc, zfn_ms)
    SELECT
        mandt, zfn_cc, zfn_ms
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_cust_mktseg;
END;
$procedure$
