CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zzwithholding_tax_baseupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/23/2020 1:38:48 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zWithholding_Tax_Base
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zzwithholding_tax_baseupdsel
    SET zzwithholding_tax_base = zzwithholding_tax_basenew;
END;
$procedure$
