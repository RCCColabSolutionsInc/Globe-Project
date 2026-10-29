CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_chargesdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  VE211163 2/11/2022 4:56:39 PM
Description: Insert DP5_Unconfirmed_Lean into ttGlobe_Lean
*/
BEGIN
    DELETE FROM dswtdir2_globe_dbo.srglobe_lean_tdir2_globe_unconfirmed_advanced_msf_chargesdelsel;
END;
$procedure$
