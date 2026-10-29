CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zlegacyzdsp_orde()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/18/2020 12:57:36 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Deferred_TDIR1_ICCBS_sap_fdef_USD:sap_fdef_USD:zLegacyzDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zlegacyzdsp_orderupdsel
    SET zlegacyzdsp_order = zlegacyzdsp_ordernew;
END;
$procedure$
