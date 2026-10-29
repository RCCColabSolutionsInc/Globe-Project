CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ska1()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ska1;
    INSERT INTO dgs4hana_tdir1_dbo.ska1 (mandt, ktopl, saknr, xbilk, sakan, bilkt, erdat, ernam, gvtyp, ktoks, mustr, vbund, xloev, xspea, xspeb, xspep, mcod1, func_area, glaccount_type, last_changed_ts)
    SELECT
        mandt, ktopl, saknr, xbilk, sakan, bilkt, erdat, ernam, gvtyp, ktoks, mustr, vbund, xloev, xspea, xspeb, xspep, mcod1, func_area, glaccount_type, last_changed_ts
        FROM dgs4hana_tdir1_dbo.vw_rt_ska1;
END;
$procedure$
