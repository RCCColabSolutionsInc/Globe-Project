CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/24/2022
Description: Summary IB and OB USD
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.summary_ib_ob_usd (account_group, direction, partner_company, remarks, service, sortvaldirection, sortvalservice, "USD AMOUNT")
    SELECT
        account_group, direction, partner_company, remarks, service, sortvaldirection, sortvalservice, "USD AMOUNT"
        FROM dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_inssel;
END;
$procedure$
