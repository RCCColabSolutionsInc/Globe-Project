CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zztextupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/15/2020 9:54:28 PM
Specification: cMap:TDIR1_MemoApp:stMEMO_Postload_TDIR1_MemoApp_ttMEMO01:ttMEMO01:zText
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01_zztextupdsel
    SET zztext = zztextnew;
END;
$procedure$
