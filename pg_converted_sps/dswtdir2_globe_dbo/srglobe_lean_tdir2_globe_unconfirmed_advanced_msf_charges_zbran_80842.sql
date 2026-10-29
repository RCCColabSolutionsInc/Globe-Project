CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zbran()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  VE211163 ON: 2/11/2022 4:56:43 PM
Specification: cMap:TDIR2_Globe:stGlobe_Lean_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges:Unconfirmed_Advanced_MSF_Charges:Brand
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_charges_zbrandupdsel
    SET zbrand = zbrandnew;
END;
$procedure$
