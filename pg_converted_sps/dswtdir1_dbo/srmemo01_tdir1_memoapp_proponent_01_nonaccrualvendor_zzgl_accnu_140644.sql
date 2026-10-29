CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zzgl_accnu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 5:30:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_NonAccrualVendor:Proponent_01_NonAccrualVendor:zGL_AccNum_SKA1
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zzgl_accnum_ska1updsel
    SET zzgl_accnum_ska1 = zzgl_accnum_ska1new;
END;
$procedure$
