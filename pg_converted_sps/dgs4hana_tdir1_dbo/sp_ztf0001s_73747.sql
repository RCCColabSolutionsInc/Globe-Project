CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0001s()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0001s;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0001s (mandt, from_system, to_system, event, bukrs, batch_no, idate, time)
    SELECT
        mandt, from_system, to_system, event, bukrs, batch_no, idate, time
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0001s;
END;
$procedure$
