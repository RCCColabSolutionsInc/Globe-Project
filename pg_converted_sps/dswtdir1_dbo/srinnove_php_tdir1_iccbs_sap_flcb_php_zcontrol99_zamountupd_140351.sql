CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zamountupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 07/30/2020
Modified by: Sindhuja Beram 09/18/2020
Description: Updates Footer zAmount as column4 from flat file sap_flcb_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zamountupdsel
    SET zcontrol99_zamount = zcontrol99_zamountnew;
END;
$procedure$
