CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_iins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:09 AM
Description: Insert TDIR2_Innove into ttInnove_Unconfirmed
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_unconfirmed (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_iinssel;
END;
$procedure$
