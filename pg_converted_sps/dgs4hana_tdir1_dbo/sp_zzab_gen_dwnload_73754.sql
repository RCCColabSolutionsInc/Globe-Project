CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zzab_gen_dwnload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zzab_gen_dwnload;
    INSERT INTO dgs4hana_tdir1_dbo.zzab_gen_dwnload (mandt, tcode, userid, appdir)
    SELECT
        mandt, tcode, userid, appdir
        FROM dgs4hana_tdir1_dbo.vw_rt_zzab_gen_dwnload;
END;
$procedure$
