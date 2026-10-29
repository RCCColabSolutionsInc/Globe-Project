CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_insert_into_dcmemoapp_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/10/2020
Modified by: Saketh Venkata Nadurumati 08/10/2020
Description: fv
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trMEMOAPP_Preload_Insert_Into_DcMemoApp_DelSel;
END;
$procedure$
