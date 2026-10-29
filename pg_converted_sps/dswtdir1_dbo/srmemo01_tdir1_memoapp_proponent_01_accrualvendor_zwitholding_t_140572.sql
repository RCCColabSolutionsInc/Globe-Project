CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zwitholding_t()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 ON: 7/23/2020 11:04:19 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_AccrualVendor:#SOURCEDATABASEOBJECT#:zWitholding_Tax_Code
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zwitholding_tax_codeupdsel
    SET zwitholding_tax_code = zwitholding_tax_codenew;
END;
$procedure$
