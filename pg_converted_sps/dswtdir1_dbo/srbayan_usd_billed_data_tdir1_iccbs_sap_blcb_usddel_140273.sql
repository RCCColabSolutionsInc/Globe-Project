CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:12 PM
Description: Insert TDIR1_ICCBS into ttBayan_USD_Billed_Data
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usddelsel;
END;
$procedure$
