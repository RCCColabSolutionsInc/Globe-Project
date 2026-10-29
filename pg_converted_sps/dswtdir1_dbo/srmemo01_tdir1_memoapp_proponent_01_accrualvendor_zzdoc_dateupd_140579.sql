CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zzdoc_dateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 5:30:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_AccrualVendor:Proponent_01_AccrualVendor:zDoc_Date
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zzdoc_dateupdsel
    SET zzdoc_date = zzdoc_datenew;
END;
$procedure$
