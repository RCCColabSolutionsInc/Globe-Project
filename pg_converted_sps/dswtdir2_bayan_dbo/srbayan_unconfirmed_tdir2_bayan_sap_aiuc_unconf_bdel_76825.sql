CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_bdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:21:55 AM
Description: Insert TDIR2_Bayan into ttBayan_Unconfirmed
*/
BEGIN
    DELETE FROM dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_bdelsel;
END;
$procedure$
