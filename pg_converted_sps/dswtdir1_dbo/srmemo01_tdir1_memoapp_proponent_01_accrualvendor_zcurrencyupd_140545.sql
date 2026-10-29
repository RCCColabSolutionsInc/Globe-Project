CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zcurrencyupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 ON: 7/23/2020 11:04:18 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_AccrualVendor:Proponent_01_AccrualVendor:zCurrency
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zcurrencyupdsel
    SET zcurrency = zcurrencynew;
END;
$procedure$
