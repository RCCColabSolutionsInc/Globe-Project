CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_adj_tdir2_bayan_sap_glunbilled_b_zcolumn08upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:26 AM
Specification: cMap:TDIR2_Bayan:stBayan_Unbilled_Adj_TDIR2_Bayan_sap_glunbilled_B:sap_glunbilled_B:Column08
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unbilled_adj_tdir2_bayan_sap_glunbilled_b_zcolumn08updsel
    SET zcolumn08 = zcolumn08new;
END;
$procedure$
