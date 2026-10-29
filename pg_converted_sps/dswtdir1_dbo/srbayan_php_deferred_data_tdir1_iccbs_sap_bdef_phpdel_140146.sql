CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:37:22 PM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Deferred_Data
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_phpdelsel;
END;
$procedure$
