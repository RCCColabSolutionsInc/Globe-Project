CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilledins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 2/1/2021 10:45:31 AM
Description: Insert TDIR2_Globe into ttGlobe_DP1_Billed
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp1_billed (zlegacydsp_order, zlegacycycle_code, data, posting_date, sapfigl, ct, st, ch_code, dp_code, amount, hits, uom, wo_ind, cc, nb_ind, brand, spa, rev_type, gl_code, spb, remarks, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, zlegacycycle_code, data, posting_date, sapfigl, ct, st, ch_code, dp_code, amount, hits, uom, wo_ind, cc, nb_ind, brand, spa, rev_type, gl_code, spb, remarks, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilledinssel;
END;
$procedure$
