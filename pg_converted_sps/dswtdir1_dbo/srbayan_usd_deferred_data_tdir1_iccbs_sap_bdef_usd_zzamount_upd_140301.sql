CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zzamount_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/3/2020 2:01:28 AM
Specification: cMap:TDIR1_ICCBS:stBayan_USD_Deferred_Data_TDIR1_ICCBS_sap_bdef_USD:sap_bdef_USD:zAmount
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zzamount_updsel
    SET "zzAmount " = "zzAmount New";
END;
$procedure$
