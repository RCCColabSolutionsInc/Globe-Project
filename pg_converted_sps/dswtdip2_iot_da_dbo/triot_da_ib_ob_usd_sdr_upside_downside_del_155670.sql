CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete IB and OB Upside and Downside
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_delsel;
END;
$procedure$
