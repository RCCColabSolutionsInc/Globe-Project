CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn03upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:20:37 AM
Specification: cMap:TDIR2_Innove:stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I:sap_aiuc_I:Column03
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn03updsel
    SET zcolumn03 = zcolumn03new;
END;
$procedure$
