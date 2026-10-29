CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/24/2022
Description: Insert Monthly SDR IB and OB
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.monthly_sdr_ib_ob (account_group, direction, "GPRS SDR", "GPRS USD", partner_company, period, "SDR to USD", "SMS SDR", "SMS USD", "Voice SDR", "Voice USD")
    SELECT
        account_group, direction, "GPRS SDR", "GPRS USD", partner_company, period, "SDR to USD", "SMS SDR", "SMS USD", "Voice SDR", "Voice USD"
        FROM dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_inssel;
END;
$procedure$
