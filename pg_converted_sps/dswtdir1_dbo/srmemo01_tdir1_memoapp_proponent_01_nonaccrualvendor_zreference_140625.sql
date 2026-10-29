CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zreference()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 ON: 7/23/2020 11:14:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_NonAccrualVendor:Proponent_01_NonAccrualVendor:zReference
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zreferenceupdsel
    SET zreference = zreferencenew;
END;
$procedure$
