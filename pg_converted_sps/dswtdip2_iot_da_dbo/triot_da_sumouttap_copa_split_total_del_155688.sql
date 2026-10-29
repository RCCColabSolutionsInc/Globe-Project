CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 09/22/2022
Modified by: Yash Raturi 09/22/2022
Description: Delete from COPA SPLIT Table
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_delsel;
END;
$procedure$
