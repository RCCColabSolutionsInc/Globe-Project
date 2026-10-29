CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 09/14/2022
Modified by: Yash Raturi 09/14/2022
Description: Delete from Load File Sub
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_delsel;
END;
$procedure$
