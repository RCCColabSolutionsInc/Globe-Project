CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t25a4()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t25a4;
    INSERT INTO dgs4hana_tdir1_dbo.t25a4 (mandt, spras, wwspa, bezek)
    SELECT
        mandt, spras, wwspa, bezek
        FROM dgs4hana_tdir1_dbo.vw_rt_t25a4;
END;
$procedure$
