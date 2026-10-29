CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_iins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:31:04 AM
Description: Insert TDIR2_Innove into ttInnove_Unbilled_Adj
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_unbilled_adj (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_iinssel;
END;
$procedure$
