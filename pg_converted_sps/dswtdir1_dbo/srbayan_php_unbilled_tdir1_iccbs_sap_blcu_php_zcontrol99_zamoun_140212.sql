CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zamoun()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/31/2020
Modified by: Sindhuja Beram 09/19/2020
Description: Updates Footer zAmount as column4 from flat file sap_blcu_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zamountupdsel
    SET zcontrol99_zamount = zcontrol99_zamountnew;
END;
$procedure$
