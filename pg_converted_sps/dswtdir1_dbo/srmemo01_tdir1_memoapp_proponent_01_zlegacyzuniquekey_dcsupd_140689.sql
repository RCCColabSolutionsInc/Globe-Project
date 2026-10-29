CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zlegacyzuniquekey_dcsupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/23/2020 2:10:57 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zLegacyzUniqueKey_DCS
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zlegacyzuniquekey_dcsupdsel
    SET zlegacyzuniquekey_dcs = zlegacyzuniquekey_dcsnew;
END;
$procedure$
