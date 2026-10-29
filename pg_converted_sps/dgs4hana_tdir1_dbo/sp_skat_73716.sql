CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_skat()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.skat;
    INSERT INTO dgs4hana_tdir1_dbo.skat (mandt, spras, ktopl, saknr, txt20, txt50, mcod1, last_changed_ts)
    SELECT
        mandt, spras, ktopl, saknr, txt20, txt50, mcod1, last_changed_ts
        FROM dgs4hana_tdir1_dbo.vw_rt_skat;
END;
$procedure$
