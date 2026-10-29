CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_flcn_prdg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_flcn_prdg;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_flcn_prdg (mandt, zflcn_pg, zffi_pl)
    SELECT
        mandt, zflcn_pg, zffi_pl
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_flcn_prdg;
END;
$procedure$
