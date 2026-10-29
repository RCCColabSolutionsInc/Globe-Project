CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn06upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/15/2021 11:58:54 PM
Specification: cMap:TDIR2_Bayan:stBayan_Billed_TDIR2_Bayan_sapglbilled:sapglbilled:Column06
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn06updsel
    SET zcolumn06 = zcolumn06new;
END;
$procedure$
