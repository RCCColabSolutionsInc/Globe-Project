CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_adj_tdir2_bayan_sap_glunbilled_bdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:21:23 AM
Description: Insert TDIR2_Bayan into ttBayan_Unbilled_Adj
*/
BEGIN
    DELETE FROM dswtdir2_bayan_dbo.srbayan_unbilled_adj_tdir2_bayan_sap_glunbilled_bdelsel;
END;
$procedure$
