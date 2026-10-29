CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zzwithhold()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 5:30:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_NonAccrualVendor:Proponent_01_NonAccrualVendor:zWithholding_Tax_Type
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zzwithholding_tax_typeupdsel
    SET zzwithholding_tax_type = zzwithholding_tax_typenew;
END;
$procedure$
