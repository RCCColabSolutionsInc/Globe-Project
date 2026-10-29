CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exportsdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0020 8/29/2020 9:10:41 PM
Description: Insert TDIR1_ICCBS into ttPostload_Innove
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exportsdelsel;
END;
$procedure$
