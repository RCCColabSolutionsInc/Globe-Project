CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zlega()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  VE211163 ON: 2/11/2022 4:56:42 PM
Specification: cMap:TDIR2_Globe:stGlobe_Lean_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges:Unconfirmed_Advanced_MSF_Charges:zLegacyDSP_Order
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zlegacydsp_orderupdsel
    SET zlegacydsp_order = zlegacydsp_ordernew;
END;
$procedure$
