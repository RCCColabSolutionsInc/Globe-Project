CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_insert_into_dcmemoapp_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/10/2020
Modified by: Saketh Venkata Nadurumati 08/10/2020
Description: Delete Load Failed Records into DC Page
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemoapp_dcs_postload_insert_into_dcmemoapp_delsel;
END;
$procedure$
