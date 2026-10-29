CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0368()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0368;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0368 (mandt, bukrs, zrev_it, zfn_pl, vbund, zpk_debit, zgl_debit, zpk_credit, zgl_credit, zoct_flg, zvat_flg, zuonr, pprctr, kostl, zdpk_debit, zdgl_debit, zdpk_credit, zdgl_credit, acct_cat, acct_catpk, acct_catgl, flg_rev, revpk_d, revgl_d, revpk_c, revgl_c, rev_rate, datbu, uzeit, uname)
    SELECT
        mandt, bukrs, zrev_it, zfn_pl, vbund, zpk_debit, zgl_debit, zpk_credit, zgl_credit, zoct_flg, zvat_flg, zuonr, pprctr, kostl, zdpk_debit, zdgl_debit, zdpk_credit, zdgl_credit, acct_cat, acct_catpk, acct_catgl, flg_rev, revpk_d, revgl_d, revpk_c, revgl_c, rev_rate, datbu, uzeit, uname
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0368;
END;
$procedure$
