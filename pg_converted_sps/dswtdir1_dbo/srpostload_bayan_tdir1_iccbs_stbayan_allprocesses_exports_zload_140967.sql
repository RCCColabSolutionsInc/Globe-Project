CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exports_zload()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/15/2020 11:42:46 PM
Specification: cMap:TDIR1_ICCBS:stPostload_Bayan_TDIR1_ICCBS_stBayan_AllProcesses_Exports:#SOURCEDATABASEOBJECT#:zLoaded
*/
BEGIN
    UPDATE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exports_zloadedupdsel
    SET zloaded = zloadednew;
END;
$procedure$
