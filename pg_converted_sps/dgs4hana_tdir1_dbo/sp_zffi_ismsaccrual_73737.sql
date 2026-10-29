CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_ismsaccrual()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_ismsaccrual;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_ismsaccrual (mandt, ioind, zuonr, wwspa, wwbrd, wwst, hkont, subprod, prctr, zrate, valdate)
    SELECT
        mandt, ioind, zuonr, wwspa, wwbrd, wwst, hkont, subprod, prctr, zrate, valdate
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_ismsaccrual;
END;
$procedure$
