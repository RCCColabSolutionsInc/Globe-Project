CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilleddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/16/2021 12:08:20 AM
Description: Insert TDIR2_Innove into ttInnove_Billed
*/
BEGIN
    DELETE FROM dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilleddelsel;
END;
$procedure$
