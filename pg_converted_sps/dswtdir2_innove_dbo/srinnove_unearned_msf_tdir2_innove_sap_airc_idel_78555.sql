CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_idel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 3:58:23 AM
Description: Insert TDIR2_Innove into ttInnove_Unearned_MSF
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_idelsel;
END;
$procedure$
