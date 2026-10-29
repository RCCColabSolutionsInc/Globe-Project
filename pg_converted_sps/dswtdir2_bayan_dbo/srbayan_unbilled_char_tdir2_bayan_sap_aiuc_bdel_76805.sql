CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_bdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:21:14 AM
Description: Insert TDIR2_Bayan into ttBayan_Unbilled_Char
*/
BEGIN
    DELETE FROM dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_bdelsel;
END;
$procedure$
