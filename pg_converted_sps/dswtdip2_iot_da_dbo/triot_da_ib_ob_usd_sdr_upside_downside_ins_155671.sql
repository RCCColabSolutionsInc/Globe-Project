CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/24/2022
Description: Insert IB and OB Upside_Downside
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.ib_ob_usd_sdr_upside_downside (account_group, accrual_amount_sdr, accrual_amount_usd, actual_amount_sdr, actual_amount_usd, column1, partner_company, "Upside/(Downside) PHP", "Upside/(Downside) SDR", "Upside/(Downside) USD")
    SELECT
        account_group, accrual_amount_sdr, accrual_amount_usd, actual_amount_sdr, actual_amount_usd, column1, partner_company, "Upside/(Downside) PHP", "Upside/(Downside) SDR", "Upside/(Downside) USD"
        FROM dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_inssel;
END;
$procedure$
