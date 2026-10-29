CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:31 PM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Billed_Data
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_phpdelsel;
END;
$procedure$
