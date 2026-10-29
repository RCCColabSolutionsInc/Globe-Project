CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t001()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t001;
    INSERT INTO dgs4hana_tdir1_dbo.t001 (mandt, bukrs, butxt, ort01, land1, waers, spras, ktopl, waabw, periv, kokfi, rcomp, adrnr, stceg, fikrs, xfmco, xfmcb, xfmca, txjcd, fmhrdate, xtemplt, buvar, fdbuk, xfdis, xvalv, xskfn, kkber, xmwsn, mregl, xgsbe, xgjrv, xkdft, xprod, xeink, xjvaa, xvvwa, xslta, xfdmm, xfdsd, xextb, ebukr, ktop2, umkrs, bukrs_glob, fstva, opvar, xcovr, txkrs, wfvar, xbbbf, xbbbe, xbbba, xbbko, xstdt, mwskv, mwska, impda, xnegp, xkkbi, wt_newwt, pp_pdate, infmt, fstvare, kopim, dkweg, offsacct, bapovar, xcos, xcession, xsplt, surccm, dtprov, dtamtc, dttaxc, dttdsp, dtaxr, xvatdate, pst_per_var, xbbsc, f_obsolete, fm_derive_acc)
    SELECT
        mandt, bukrs, butxt, ort01, land1, waers, spras, ktopl, waabw, periv, kokfi, rcomp, adrnr, stceg, fikrs, xfmco, xfmcb, xfmca, txjcd, fmhrdate, xtemplt, buvar, fdbuk, xfdis, xvalv, xskfn, kkber, xmwsn, mregl, xgsbe, xgjrv, xkdft, xprod, xeink, xjvaa, xvvwa, xslta, xfdmm, xfdsd, xextb, ebukr, ktop2, umkrs, bukrs_glob, fstva, opvar, xcovr, txkrs, wfvar, xbbbf, xbbbe, xbbba, xbbko, xstdt, mwskv, mwska, impda, xnegp, xkkbi, wt_newwt, pp_pdate, infmt, fstvare, kopim, dkweg, offsacct, bapovar, xcos, xcession, xsplt, surccm, dtprov, dtamtc, dttaxc, dttdsp, dtaxr, xvatdate, pst_per_var, xbbsc, f_obsolete, fm_derive_acc
        FROM dgs4hana_tdir1_dbo.vw_rt_t001;
END;
$procedure$
