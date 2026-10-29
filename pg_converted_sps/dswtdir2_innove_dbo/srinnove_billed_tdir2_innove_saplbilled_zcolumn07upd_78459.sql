CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_saplbilled_zcolumn07upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 12/21/2020 1:47:56 PM
Specification: cMap:TDIR2_Innove:stInnove_Billed_TDIR2_Innove_saplbilled:saplbilled:Column07
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srInnove_Billed_TDIR2_Innove_saplbilled_zColumn07UpdSel
    SET zColumn07 = zColumn07New;
END;
$procedure$
