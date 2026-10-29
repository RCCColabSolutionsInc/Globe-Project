CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_zcolumn05up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:31:07 AM
Specification: cMap:TDIR2_Innove:stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i:sap_glunbilled_i:Column05
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_zcolumn05updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
