CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zsum_of_amount()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:55 AM
Specification: cMap:TDIR2_Globe:stGlobe_DP3_Unbilled_Char_TDIR2_Globe_sap_aiuc_G:sap_aiuc_G:Sum_of_Amount
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zsum_of_amountupdsel
    SET zsum_of_amount = zsum_of_amountnew;
END;
$procedure$
