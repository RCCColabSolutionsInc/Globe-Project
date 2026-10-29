CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zrecordcountup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 07/30/2020
Modified by: Sindhuja Beram 09/18/2020
Description: Updates Footer zRecordCount as column3 from flat file sap_flcb_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zrecordcountupdsel
    SET zcontrol99_zrecordcount = zcontrol99_zrecordcountnew;
END;
$procedure$
