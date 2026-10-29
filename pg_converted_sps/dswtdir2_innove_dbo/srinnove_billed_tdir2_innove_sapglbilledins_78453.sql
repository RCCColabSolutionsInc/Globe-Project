CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilledins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/16/2021 12:08:20 AM
Description: Insert TDIR2_Innove into ttInnove_Billed
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_billed (zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilledinssel;
END;
$procedure$
