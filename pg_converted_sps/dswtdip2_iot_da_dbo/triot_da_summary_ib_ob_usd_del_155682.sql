CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete Summary IB and OB USD
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_delsel;
END;
$procedure$
