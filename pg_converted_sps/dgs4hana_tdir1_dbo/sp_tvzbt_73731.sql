CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_tvzbt()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.tvzbt;
    INSERT INTO dgs4hana_tdir1_dbo.tvzbt (mandt, spras, zterm, vtext)
    SELECT
        mandt, spras, zterm, vtext
        FROM dgs4hana_tdir1_dbo.vw_rt_tvzbt;
END;
$procedure$
