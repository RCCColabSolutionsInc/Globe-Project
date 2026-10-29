CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_zerror_load_counter_dcs_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/06/2020
Modified by: Saketh Venkata Nadurumati 08/06/2020
Description: Update zErroLoad DCS Flag
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_postload_zerror_load_counter_dcs_updsel
    SET zerror_load_dcs = zerror_load_dcsnew;
END;
$procedure$
