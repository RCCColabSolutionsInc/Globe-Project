CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zactiveupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/16/2020 1:25:52 AM
Specification: cMap:TDIR1_MemoApp:stMEMO_Postload_TDIR1_MemoApp_ttMEMO01:ttMEMO01:zActive
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zactiveupdsel
    SET zactive = zactivenew;
END;
$procedure$
