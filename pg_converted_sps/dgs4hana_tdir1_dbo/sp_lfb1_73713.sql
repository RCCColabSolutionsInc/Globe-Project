CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_lfb1()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.lfb1;
    INSERT INTO dgs4hana_tdir1_dbo.lfb1 (mandt, lifnr, bukrs, pernr, erdat, ernam, sperr, loevm, zuawa, akont, begru, vzskz, zwels, xverr, zahls, zterm, eikto, zsabe, kverm, fdgrv, busab, lnrze, lnrzb, zindt, zinrt, datlz, xdezv, webtr, kultg, reprf, togru, hbkid, xpore, qsznr, qszdt, qsskz, blnkz, mindk, altkn, zgrup, mgrup, uzawe, qsrec, qsbgr, qland, xedip, frgrp, togrr, tlfxs, intad, xlfzb, guzte, gricd, gridt, xausz, cerdt, confs, updat, uptim, nodel, tlfns, avsnd, ad_hash, j_sc_subcontype, j_sc_compdate, j_sc_offsm, j_sc_offsr, basis_pnt, gmvkzk, prepay_relevant, assign_test, cvp_xblck_b, ciiucode, lfb1_eew_cc, zbokd, zqsskz, zqszdt, zqsznr, zmindat, brsch, wrbtr, waers, forgn, share_in_foreign, notes, active)
    SELECT
        mandt, lifnr, bukrs, pernr, erdat, ernam, sperr, loevm, zuawa, akont, begru, vzskz, zwels, xverr, zahls, zterm, eikto, zsabe, kverm, fdgrv, busab, lnrze, lnrzb, zindt, zinrt, datlz, xdezv, webtr, kultg, reprf, togru, hbkid, xpore, qsznr, qszdt, qsskz, blnkz, mindk, altkn, zgrup, mgrup, uzawe, qsrec, qsbgr, qland, xedip, frgrp, togrr, tlfxs, intad, xlfzb, guzte, gricd, gridt, xausz, cerdt, confs, updat, uptim, nodel, tlfns, avsnd, ad_hash, j_sc_subcontype, j_sc_compdate, j_sc_offsm, j_sc_offsr, basis_pnt, gmvkzk, prepay_relevant, assign_test, cvp_xblck_b, ciiucode, lfb1_eew_cc, zbokd, zqsskz, zqszdt, zqsznr, zmindat, brsch, wrbtr, waers, forgn, share_in_foreign, notes, active
        FROM dgs4hana_tdir1_dbo.vw_rt_lfb1;
END;
$procedure$
