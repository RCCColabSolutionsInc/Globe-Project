CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_zerrormessage_load_dcs_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/06/2020
Modified by: Saketh Venkata Nadurumati 08/06/2020
Description: Update zErrorMessage DCS Flag
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_postload_zerrormessage_load_dcs_updsel
    SET zerrormessage_load_dcs = zerrormessage_load_dcsnew;
END;
$procedure$
