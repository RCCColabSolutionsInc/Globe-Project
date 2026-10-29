CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exportsins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/15/2020 11:42:44 PM
Description: Insert TDIR1_ICCBS into ttPostload_Bayan
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttpostload_bayan (zlegacyzpostload_zdsp_uniquekey, zlegacyzinputfilename, zlegacyzdsp_order, zactive, zsource, zduplicate)
    SELECT
        zlegacyzpostload_zdsp_uniquekey, zlegacyzinputfilename, zlegacyzdsp_order, zactive, zsource, zduplicate
        FROM dswtdir1_dbo.srpostload_bayan_tdir1_iccbs_stbayan_allprocesses_exportsinssel;
END;
$procedure$
