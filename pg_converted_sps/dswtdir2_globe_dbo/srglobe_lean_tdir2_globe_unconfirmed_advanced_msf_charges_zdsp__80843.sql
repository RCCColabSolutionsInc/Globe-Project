CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zdsp_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  VE211163 ON: 2/11/2022 4:56:42 PM
Specification: cMap:TDIR2_Globe:stGlobe_Lean_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges:Unconfirmed_Advanced_MSF_Charges:zDSP_Order
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
