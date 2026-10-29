CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_i_zcolumn15upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 3:58:24 AM
Specification: cMap:TDIR2_Innove:stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I:sap_airc_I:Column15
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_i_zcolumn15updsel
    SET zcolumn15 = zcolumn15new;
END;
$procedure$
