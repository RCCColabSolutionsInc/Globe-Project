CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zzwithholding_tax_baseup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 10:05:13 PM
Specification: cMap:TDIR1_MemoApp:stMEMO_Postload_TDIR1_MemoApp_ttMEMO01:ttMEMO01:zWithholding_Tax_Base
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zzwithholding_tax_baseupdsel
    SET zzwithholding_tax_base = zzwithholding_tax_basenew;
END;
$procedure$
