CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:02 PM
Description: Insert TDIR1_ICCBS into ttBayan_USD_Deferred_Data
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usddelsel;
END;
$procedure$
