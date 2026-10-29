CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_tcurr()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.tcurr;
    INSERT INTO dgs4hana_tdir1_dbo.tcurr (mandt, kurst, fcurr, tcurr, gdatu, ukurs, ffact, tfact)
    SELECT
        mandt, kurst, fcurr, tcurr, gdatu, ukurs, ffact, tfact
        FROM dgs4hana_tdir1_dbo.vw_rt_tcurr;
END;
$procedure$
