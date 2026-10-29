CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_idel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:20:35 AM
Description: Insert TDIR2_Innove into ttInnove_Unbilled_Char
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_idelsel;
END;
$procedure$
