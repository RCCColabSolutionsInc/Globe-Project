CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete from Monthly SDR table
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_delsel;
END;
$procedure$
