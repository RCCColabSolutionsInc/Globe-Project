CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zwithholding_values_multiple_up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/27/2021
Modified by: Uma Guduru 03/27/2021
Description: remediate Withholding_Tax_Base or Type or Code has multiple values.
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zwithholding_values_multiple_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
