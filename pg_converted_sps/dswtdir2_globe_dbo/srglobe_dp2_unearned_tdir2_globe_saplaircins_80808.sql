CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:54 AM
Description: Insert TDIR2_Globe into ttGlobe_DP2_Unearned
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp2_unearned (zlegacydsp_order, data, posting_date, sapfigl, ct, st, ch_code, amount, wo_ind, cc, gl_code, nb_ind, brand, umsf, diff, spa, rev_type, spb, remarks, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, data, posting_date, sapfigl, ct, st, ch_code, amount, wo_ind, cc, gl_code, nb_ind, brand, umsf, diff, spa, rev_type, spb, remarks, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircinssel;
END;
$procedure$
