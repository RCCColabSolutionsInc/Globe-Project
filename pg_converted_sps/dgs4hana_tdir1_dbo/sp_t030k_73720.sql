CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t030k()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t030k;
    INSERT INTO dgs4hana_tdir1_dbo.t030k (mandt, ktopl, ktosl, mwskz, konts, konth, land1)
    SELECT
        mandt, ktopl, ktosl, mwskz, konts, konth, land1
        FROM dgs4hana_tdir1_dbo.vw_rt_t030k;
END;
$procedure$
