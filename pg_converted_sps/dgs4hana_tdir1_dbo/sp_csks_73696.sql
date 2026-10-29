CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_csks()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.csks;
    INSERT INTO dgs4hana_tdir1_dbo.csks (mandt, kokrs, kostl, datbi, datab, bkzkp, pkzkp, bukrs, gsber, kosar, verak, verak_user, waers, kalsm, txjcd, prctr, werks, logsystem, ersda, usnam, bkzks, bkzer, bkzob, pkzks, pkzer, vmeth, mgefl, abtei, nkost, kvewe, kappl, koszschl, land1, anred, name1, name2, name3, name4, ort01, ort02, stras, pfach, pstlz, pstl2, regio, spras, telbx, telf1, telf2, telfx, teltx, telx1, datlt, drnam, khinr, cckey, kompl, stakz, objnr, funkt, afunk, cpi_templ, cpd_templ, func_area, sci_templ, scd_templ, vname, recid, etype, jv_otype, jv_jibcl, jv_jibsa, ferc_ind, ski_templ, skd_templ, eew_csks_ps_dummy)
    SELECT
        mandt, kokrs, kostl, datbi, datab, bkzkp, pkzkp, bukrs, gsber, kosar, verak, verak_user, waers, kalsm, txjcd, prctr, werks, logsystem, ersda, usnam, bkzks, bkzer, bkzob, pkzks, pkzer, vmeth, mgefl, abtei, nkost, kvewe, kappl, koszschl, land1, anred, name1, name2, name3, name4, ort01, ort02, stras, pfach, pstlz, pstl2, regio, spras, telbx, telf1, telf2, telfx, teltx, telx1, datlt, drnam, khinr, cckey, kompl, stakz, objnr, funkt, afunk, cpi_templ, cpd_templ, func_area, sci_templ, scd_templ, vname, recid, etype, jv_otype, jv_jibcl, jv_jibsa, ferc_ind, ski_templ, skd_templ, eew_csks_ps_dummy
        FROM dgs4hana_tdir1_dbo.vw_rt_csks;
END;
$procedure$
