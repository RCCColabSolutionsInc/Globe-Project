CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_iins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:20:35 AM
Description: Insert TDIR2_Innove into ttInnove_Unbilled_Char
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_unbilled_char (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, column14, column15, column16, column17, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, column14, column15, column16, column17, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_iinssel;
END;
$procedure$
