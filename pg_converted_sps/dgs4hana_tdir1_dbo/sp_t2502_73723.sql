CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t2502()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t2502;
    INSERT INTO dgs4hana_tdir1_dbo.t2502 (mandt, wwpdt)
    SELECT
        mandt, wwpdt
        FROM dgs4hana_tdir1_dbo.vw_rt_t2502;
END;
$procedure$
