CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0322()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0322;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0322 (mandt, bukrs, lifnr, datum, uzeit, uname)
    SELECT
        mandt, bukrs, lifnr, datum, uzeit, uname
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0322;
END;
$procedure$
