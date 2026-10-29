CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exports_zlo()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0020 ON: 8/29/2020 9:10:42 PM
Specification: cMap:TDIR1_ICCBS:stPostload_Innove_TDIR1_ICCBS_stInnove_AllProcesses_Exports:#SOURCEDATABASEOBJECT#:zLoaded
*/
BEGIN
    UPDATE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exports_zloadedupdsel
    SET zloaded = zloadednew;
END;
$procedure$
