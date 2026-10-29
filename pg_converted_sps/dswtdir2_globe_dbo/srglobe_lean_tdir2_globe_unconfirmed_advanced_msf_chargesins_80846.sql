CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_chargesins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  VE211163 ON: 2/11/2022 4:56:39 PM
Description: Insert DP5_Unconfirmed_Lean into ttGlobe_Lean
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_lean (zlegacydsp_order, posting_date, spa, rev_type, gl, spb, brand, tax, amount_net, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, posting_date, spa, rev_type, gl, spb, brand, tax, amount_net, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_chargesinssel;
END;
$procedure$
