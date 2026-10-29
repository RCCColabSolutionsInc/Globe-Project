CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_znew_company_codeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/16/2020 1:25:51 AM
Specification: cMap:TDIR1_MemoApp:stMEMO_Postload_TDIR1_MemoApp_ttMEMO01:ttMEMO01:zNew_Company_Code
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_znew_company_codeupdsel
    SET znew_company_code = znew_company_codenew;
END;
$procedure$
