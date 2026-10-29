CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_saplbilled_zcolumn11upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 12/21/2020 1:47:56 PM
Specification: cMap:TDIR2_Innove:stInnove_Billed_TDIR2_Innove_saplbilled:saplbilled:Column11
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srInnove_Billed_TDIR2_Innove_saplbilled_zColumn11UpdSel
    SET zColumn11 = zColumn11New;
END;
$procedure$
