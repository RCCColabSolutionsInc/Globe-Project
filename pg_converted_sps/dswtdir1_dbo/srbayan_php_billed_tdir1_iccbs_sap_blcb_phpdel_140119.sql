CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:59 PM
Description: Insert sap_blcb_PHP into ttBayan_PHP_Billed
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_phpdelsel;
END;
$procedure$
