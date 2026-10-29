CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zlegacyzuniqu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 ON: 7/23/2020 11:04:19 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_AccrualVendor:Proponent_01_AccrualVendor:zLegacyzUniqueKey_DCS
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zlegacyzuniquekey_dcsupdsel
    SET zlegacyzuniquekey_dcs = zlegacyzuniquekey_dcsnew;
END;
$procedure$
