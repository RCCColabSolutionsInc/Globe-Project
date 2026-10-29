CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zlegacydsp_ord()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:55 AM
Specification: cMap:TDIR2_Globe:stGlobe_DP3_Unbilled_Char_TDIR2_Globe_sap_aiuc_G:sap_aiuc_G:zLegacyDSP_Order
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zlegacydsp_orderupdsel
    SET zlegacydsp_order = zlegacydsp_ordernew;
END;
$procedure$
