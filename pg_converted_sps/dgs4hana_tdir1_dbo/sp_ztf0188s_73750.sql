CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0188s()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0188s;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0188s (mandt, ccode, chcode, pstkey, glcode, pline, sline, sgroup, vatind, pstkey_cera, glcode_cera)
    SELECT
        mandt, ccode, chcode, pstkey, glcode, pline, sline, sgroup, vatind, pstkey_cera, glcode_cera
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0188s;
END;
$procedure$
