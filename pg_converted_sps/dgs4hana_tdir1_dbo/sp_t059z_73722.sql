CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t059z()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t059z;
    INSERT INTO dgs4hana_tdir1_dbo.t059z (mandt, land1, witht, wt_withcd, qscod, qproz, qsatz, qsatr, xqfor, regio, fprcd, qekar, wt_posin, wt_ratez, wt_raten, withcd2)
    SELECT
        mandt, land1, witht, wt_withcd, qscod, qproz, qsatz, qsatr, xqfor, regio, fprcd, qekar, wt_posin, wt_ratez, wt_raten, withcd2
        FROM dgs4hana_tdir1_dbo.vw_rt_t059z;
END;
$procedure$
