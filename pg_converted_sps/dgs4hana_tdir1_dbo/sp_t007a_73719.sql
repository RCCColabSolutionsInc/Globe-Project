CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t007a()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t007a;
    INSERT INTO dgs4hana_tdir1_dbo.t007a (mandt, kalsm, mwskz, pruef, mwart, xmstu, zmwsk, egrkz, xslta, procd, txind, txrel, lstml, j_1busage, j_1biss, j_1btaxlw1, j_1btaxlw2, j_1btxicex, j_1btxipex, tolerance, zmwsk_esa, zmwsk_ese, newdeftax, j_1btaxlw4, j_1btaxlw5, xinact, mossc)
    SELECT
        mandt, kalsm, mwskz, pruef, mwart, xmstu, zmwsk, egrkz, xslta, procd, txind, txrel, lstml, j_1busage, j_1biss, j_1btaxlw1, j_1btaxlw2, j_1btxicex, j_1btxipex, tolerance, zmwsk_esa, zmwsk_ese, newdeftax, j_1btaxlw4, j_1btaxlw5, xinact, mossc
        FROM dgs4hana_tdir1_dbo.vw_rt_t007a;
END;
$procedure$
