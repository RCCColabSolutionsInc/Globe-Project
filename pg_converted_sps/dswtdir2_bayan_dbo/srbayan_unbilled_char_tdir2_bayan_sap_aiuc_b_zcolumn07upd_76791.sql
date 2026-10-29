CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_b_zcolumn07upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:16 AM
Specification: cMap:TDIR2_Bayan:stBayan_Unbilled_Char_TDIR2_Bayan_sap_aiuc_B:sap_aiuc_B:Column07
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_b_zcolumn07updsel
    SET zcolumn07 = zcolumn07new;
END;
$procedure$
