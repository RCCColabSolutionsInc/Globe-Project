CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zgl_acctup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/13/2020 2:10:41 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_NonAccrualVendor:Proponent_01_NonAccrualVendor:zGL_Acct
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zgl_acctupdsel
    SET zgl_acct = zgl_acctnew;
END;
$procedure$
