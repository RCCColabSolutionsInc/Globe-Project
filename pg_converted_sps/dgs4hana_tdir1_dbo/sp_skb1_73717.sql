CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_skb1()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.skb1;
    INSERT INTO dgs4hana_tdir1_dbo.skb1 (mandt, bukrs, saknr, begru, busab, datlz, erdat, ernam, fdgrv, fdlev, fipls, fstag, hbkid, hktid, kdfsl, mitkz, mwskz, stext, vzskz, waers, wmeth, xgkon, xintb, xkres, xloeb, xnkon, xopvw, xspeb, zindt, zinrt, zuawa, altkt, xmitk, recid, fipos, xmwno, xsalh, bewgp, infky, togru, xlgclr, mcakey, cochanged, last_changed_ts)
    SELECT
        mandt, bukrs, saknr, begru, busab, datlz, erdat, ernam, fdgrv, fdlev, fipls, fstag, hbkid, hktid, kdfsl, mitkz, mwskz, stext, vzskz, waers, wmeth, xgkon, xintb, xkres, xloeb, xnkon, xopvw, xspeb, zindt, zinrt, zuawa, altkt, xmitk, recid, fipos, xmwno, xsalh, bewgp, infky, togru, xlgclr, mcakey, cochanged, last_changed_ts
        FROM dgs4hana_tdir1_dbo.vw_rt_skb1;
END;
$procedure$
