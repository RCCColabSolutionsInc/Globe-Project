CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zcontrol99_zrecordc()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 07/30/2020
Modified by: Sindhuja Beram 09/19/2020
Description: Updates Footer zRecordCount as column3 from flat file sap_blcb_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zcontrol99_zrecordcountupdsel
    SET zcontrol99_zrecordcount = zcontrol99_zrecordcountnew;
END;
$procedure$
