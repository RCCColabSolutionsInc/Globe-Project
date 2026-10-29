CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zgl_accnum_exist_saknrupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/23/2020 2:10:57 AM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01:Proponent_01:zGL_AccNum_Exist_SAKNR
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_zgl_accnum_exist_saknrupdsel
    SET zgl_accnum_exist_saknr = zgl_accnum_exist_saknrnew;
END;
$procedure$
