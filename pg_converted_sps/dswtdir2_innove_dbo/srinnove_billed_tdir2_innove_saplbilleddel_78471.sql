CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_saplbilleddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 12/21/2020 2:35:57 PM
Description: Insert TDIR2_Innove into ttInnove_Billed
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srInnove_Billed_TDIR2_Innove_saplbilledDelSel;
END;
$procedure$
