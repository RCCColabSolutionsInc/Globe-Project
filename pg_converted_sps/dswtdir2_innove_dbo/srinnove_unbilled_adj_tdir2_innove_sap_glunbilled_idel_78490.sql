CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_idel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:31:04 AM
Description: Insert TDIR2_Innove into ttInnove_Unbilled_Adj
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_idelsel;
END;
$procedure$
