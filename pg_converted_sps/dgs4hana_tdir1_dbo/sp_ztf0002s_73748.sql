CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0002s()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0002s;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0002s (mandt, ccode, chcode, dpcode, pstkey, glcode, sline, sgroup, vatind, devrevind, vatrate, pstkey2, glcodetax)
    SELECT
        mandt, ccode, chcode, dpcode, pstkey, glcode, sline, sgroup, vatind, devrevind, vatrate, pstkey2, glcodetax
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0002s;
END;
$procedure$
