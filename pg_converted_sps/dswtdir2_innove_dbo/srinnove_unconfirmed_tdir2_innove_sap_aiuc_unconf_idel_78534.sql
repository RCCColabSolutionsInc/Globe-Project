CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_idel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:21:09 AM
Description: Insert TDIR2_Innove into ttInnove_Unconfirmed
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_idelsel;
END;
$procedure$
