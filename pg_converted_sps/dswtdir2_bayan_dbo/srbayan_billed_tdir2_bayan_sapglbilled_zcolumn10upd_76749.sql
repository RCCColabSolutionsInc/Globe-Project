CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn10upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/15/2021 11:58:54 PM
Specification: cMap:TDIR2_Bayan:stBayan_Billed_TDIR2_Bayan_sapglbilled:sapglbilled:Column10
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn10updsel
    SET zcolumn10 = zcolumn10new;
END;
$procedure$
