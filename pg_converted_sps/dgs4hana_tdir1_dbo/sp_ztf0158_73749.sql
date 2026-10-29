CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0158()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0158;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0158 (mandt, lifnr, bukrs, ewt, ewt2, validfr, zdisc, sm_dcode, gx_dcode, zerovat, datum, uzeit, uname)
    SELECT
        mandt, lifnr, bukrs, ewt, ewt2, validfr, zdisc, sm_dcode, gx_dcode, zerovat, datum, uzeit, uname
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0158;
END;
$procedure$
