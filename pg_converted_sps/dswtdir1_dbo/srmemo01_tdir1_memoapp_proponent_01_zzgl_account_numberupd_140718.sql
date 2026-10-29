CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zzgl_account_numberupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/23/2020 1:38:48 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zGL_Account_Number
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zzgl_account_numberupdsel
    SET zzgl_account_number = zzgl_account_numbernew;
END;
$procedure$
