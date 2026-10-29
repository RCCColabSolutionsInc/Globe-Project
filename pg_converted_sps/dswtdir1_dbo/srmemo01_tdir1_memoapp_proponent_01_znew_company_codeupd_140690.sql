CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_znew_company_codeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/23/2020 2:10:55 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zNew_Company_Code
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_znew_company_codeupdsel
    SET znew_company_code = znew_company_codenew;
END;
$procedure$
