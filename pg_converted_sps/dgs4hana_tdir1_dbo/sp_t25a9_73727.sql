CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t25a9()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t25a9;
    INSERT INTO dgs4hana_tdir1_dbo.t25a9 (mandt, spras, wwst, bezek)
    SELECT
        mandt, spras, wwst, bezek
        FROM dgs4hana_tdir1_dbo.vw_rt_t25a9;
END;
$procedure$
