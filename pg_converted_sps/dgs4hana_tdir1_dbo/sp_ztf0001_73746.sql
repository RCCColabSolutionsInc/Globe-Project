CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0001()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0001;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0001 (mandt, from_system, to_system, event, bukrs, batch_no, uname, idate, time)
    SELECT
        mandt, from_system, to_system, event, bukrs, batch_no, uname, idate, time
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0001;
END;
$procedure$
