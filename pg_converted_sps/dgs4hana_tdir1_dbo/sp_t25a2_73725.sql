CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t25a2()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t25a2;
    INSERT INTO dgs4hana_tdir1_dbo.t25a2 (mandt, spras, wwpdt, bezek)
    SELECT
        mandt, spras, wwpdt, bezek
        FROM dgs4hana_tdir1_dbo.vw_rt_t25a2;
END;
$procedure$
