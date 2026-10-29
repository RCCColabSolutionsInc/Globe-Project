CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_gdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:19:54 AM
Description: Insert DP3_Unbilled_Char into ttGlobe_DP3_Unbilled_Char
*/
BEGIN
    DELETE FROM dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_gdelsel;
END;
$procedure$
