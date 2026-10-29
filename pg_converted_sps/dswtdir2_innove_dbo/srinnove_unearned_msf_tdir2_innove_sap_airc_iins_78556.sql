CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_iins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 3:58:23 AM
Description: Insert TDIR2_Innove into ttInnove_Unearned_MSF
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_unearned_msf (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, column14, column15, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, zdsp_order, column11, column12, column13, column14, column15, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_iinssel;
END;
$procedure$
