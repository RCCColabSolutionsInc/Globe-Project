CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:49 PM
Description: Insert sap_blcu_PHP into ttBayan_PHP_unbilled
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpdelsel;
END;
$procedure$
