CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn15upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/16/2021 12:08:21 AM
Specification: cMap:TDIR2_Innove:stInnove_Billed_TDIR2_Innove_sapglbilled:sapglbilled:Column15
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn15updsel
    SET zcolumn15 = zcolumn15new;
END;
$procedure$
