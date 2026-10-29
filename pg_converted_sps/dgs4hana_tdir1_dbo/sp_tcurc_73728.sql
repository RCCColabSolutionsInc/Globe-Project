CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_tcurc()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.tcurc;
    INSERT INTO dgs4hana_tdir1_dbo.tcurc (mandt, waers, isocd, altwr, gdatu, xprimary)
    SELECT
        mandt, waers, isocd, altwr, gdatu, xprimary
        FROM dgs4hana_tdir1_dbo.vw_rt_tcurc;
END;
$procedure$
