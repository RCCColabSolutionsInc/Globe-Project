CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 9/3/2020 12:48:26 AM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Unbilled_Data
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_phpdelsel;
END;
$procedure$
