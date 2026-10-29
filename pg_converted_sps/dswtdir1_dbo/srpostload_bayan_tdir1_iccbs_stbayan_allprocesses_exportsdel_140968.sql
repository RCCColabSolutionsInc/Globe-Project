CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exportsdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 9/15/2020 11:42:44 PM
Description: Insert TDIR1_ICCBS into ttPostload_Bayan
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exportsdelsel;
END;
$procedure$
