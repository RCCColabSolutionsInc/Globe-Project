CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn06upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/16/2021 12:08:21 AM
Specification: cMap:TDIR2_Innove:stInnove_Billed_TDIR2_Innove_sapglbilled:sapglbilled:Column06
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn06updsel
    SET zcolumn06 = zcolumn06new;
END;
$procedure$
