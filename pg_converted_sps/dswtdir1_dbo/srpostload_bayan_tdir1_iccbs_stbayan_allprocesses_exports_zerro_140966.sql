CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exports_zerro()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/15/2020 11:42:45 PM
Specification: cMap:TDIR1_ICCBS:stPostload_Bayan_TDIR1_ICCBS_stBayan_AllProcesses_Exports:stBayan_AllProcesses_Exports:zErrorMessage_Load
*/
BEGIN
    UPDATE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exports_zerrormessage_loadupdsel
    SET zerrormessage_load = zerrormessage_loadnew;
END;
$procedure$
