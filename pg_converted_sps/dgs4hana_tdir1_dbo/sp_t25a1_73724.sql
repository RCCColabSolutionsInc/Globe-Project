CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t25a1()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t25a1;
    INSERT INTO dgs4hana_tdir1_dbo.t25a1 (mandt, spras, wwbrd, bezek)
    SELECT
        mandt, spras, wwbrd, bezek
        FROM dgs4hana_tdir1_dbo.vw_rt_t25a1;
END;
$procedure$
