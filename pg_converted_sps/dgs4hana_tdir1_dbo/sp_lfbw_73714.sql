CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_lfbw()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.lfbw;
    INSERT INTO dgs4hana_tdir1_dbo.lfbw (mandt, lifnr, bukrs, witht, wt_subjct, qsrec, wt_wtstcd, wt_withcd, wt_exnr, wt_exrt, wt_exdf, wt_exdt, wt_wtexrs)
    SELECT
        mandt, lifnr, bukrs, witht, wt_subjct, qsrec, wt_wtstcd, wt_withcd, wt_exnr, wt_exrt, wt_exdf, wt_exdt, wt_wtexrs
        FROM dgs4hana_tdir1_dbo.vw_rt_lfbw;
END;
$procedure$
