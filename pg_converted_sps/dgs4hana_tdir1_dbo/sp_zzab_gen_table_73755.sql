CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zzab_gen_table()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zzab_gen_table;
    INSERT INTO dgs4hana_tdir1_dbo.zzab_gen_table (mandt, usnam, tname, se16o, se16n, repid, uname, aedat, cputm)
    SELECT
        mandt, usnam, tname, se16o, se16n, repid, uname, aedat, cputm
        FROM dgs4hana_tdir1_dbo.vw_rt_zzab_gen_table;
END;
$procedure$
