CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zservice_type_up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/30/2020 1:55:09 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Deferred_TDIR1_ICCBS_sap_fdef_USD:sap_fdef_USD:zService_Type
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zservice_type_updsel
    SET "zService_Type " = "zService_Type New";
END;
$procedure$
