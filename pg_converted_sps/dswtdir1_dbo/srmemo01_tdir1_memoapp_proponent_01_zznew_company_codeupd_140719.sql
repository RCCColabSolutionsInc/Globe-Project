CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zznew_company_codeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/23/2020 1:38:48 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zNew_Company_Code
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zznew_company_codeupdsel
    SET zznew_company_code = zznew_company_codenew;
END;
$procedure$
