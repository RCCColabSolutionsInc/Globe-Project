CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_saplbilledins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 12/21/2020 2:35:57 PM
Description: Insert TDIR2_Innove into ttInnove_Billed
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_billed (zlegacydsp_order, zlegacycycle_code, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, zlegacycycle_code, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srInnove_Billed_TDIR2_Innove_saplbilledInsSel;
END;
$procedure$
