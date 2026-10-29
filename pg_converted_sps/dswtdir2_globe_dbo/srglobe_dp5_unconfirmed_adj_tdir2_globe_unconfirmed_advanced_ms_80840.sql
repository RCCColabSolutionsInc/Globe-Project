CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_unconfirmed_advanced_ms()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/10/2021 11:42:29 AM
Description: Insert DP5_Unconfirmed_Adj into ttGlobe_DP5_Unconfirmed_Adj
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp5_unconfirmed_adj (zlegacydsp_order, posting_date, spa, rev_type, gl, spb, brand, tax, amount_net, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, posting_date, spa, rev_type, gl, spb, brand, tax, amount_net, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_dp5_unconfirmed_adj_tdir2_globe_unconfirmed_advanced_msf_chargesinssel;
END;
$procedure$
