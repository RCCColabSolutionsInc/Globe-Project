CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_preload_insert_into_dcmemoapp_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/10/2020
Modified by: Saketh Venkata Nadurumati 08/10/2020
Description: Delete From DCS page
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemoapp_dcs_preload_insert_into_dcmemoapp_delsel;
END;
$procedure$
