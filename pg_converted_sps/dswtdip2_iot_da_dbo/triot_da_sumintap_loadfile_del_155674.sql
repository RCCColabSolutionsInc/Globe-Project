CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete from Summary Intap Loadfile Table
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_delsel;
END;
$procedure$
