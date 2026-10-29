CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zzvat_tax_cod()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 5:30:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_AccrualVendor:Proponent_01_AccrualVendor:zVat_Tax_Code
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zzvat_tax_codeupdsel
    SET zzvat_tax_code = zzvat_tax_codenew;
END;
$procedure$
