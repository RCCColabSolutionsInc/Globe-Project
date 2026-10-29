CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exports_zer()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0020 ON: 8/29/2020 9:10:42 PM
Specification: cMap:TDIR1_ICCBS:stPostload_Innove_TDIR1_ICCBS_stInnove_AllProcesses_Exports:stInnove_AllProcesses_Exports:zErrorMessage_Load
*/
BEGIN
    UPDATE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exports_zerrormessage_loadupdsel
    SET zerrormessage_load = zerrormessage_loadnew;
END;
$procedure$
