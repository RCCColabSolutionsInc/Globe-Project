CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:33:39 PM
Description: Insert sap_flcu_PHP into ttInnove_PHP_Unbilled
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_phpdelsel;
END;
$procedure$
