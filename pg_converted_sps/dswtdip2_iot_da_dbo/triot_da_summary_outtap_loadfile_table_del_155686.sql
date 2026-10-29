CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_outtap_loadfile_table_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete data from Outtap Loadfile Table
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_summary_outtap_loadfile_table_delsel;
END;
$procedure$
