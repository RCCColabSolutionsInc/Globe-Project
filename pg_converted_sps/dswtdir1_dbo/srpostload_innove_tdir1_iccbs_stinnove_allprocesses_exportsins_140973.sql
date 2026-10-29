CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exportsins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0020 ON: 8/29/2020 9:10:41 PM
Description: Insert TDIR1_ICCBS into ttPostload_Innove
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttpostload_innove (zlegacyzinputfilename, zlegacyzdsp_order, zlegacyzpostload_zdsp_uniquekey, zloaded, zerror_load, zerrormessage_load, zerror_load_log_date, zinputfileprocessed_date, zpostload_zdsp_uniquekey, zactive, zsource, zduplicate)
    SELECT
        zlegacyzinputfilename, zlegacyzdsp_order, zlegacyzpostload_zdsp_uniquekey, zloaded, zerror_load, zerrormessage_load, zerror_load_log_date, zinputfileprocessed_date, zpostload_zdsp_uniquekey, zactive, zsource, zduplicate
        FROM dswtdir1_dbo.srpostload_innove_tdir1_iccbs_stinnove_allprocesses_exportsinssel;
END;
$procedure$
