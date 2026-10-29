CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_outtap_cn_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/24/2022
Description: Insert Summary OutTap CN
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.summary_outtap_cn_table (account_group, description, direction, gprs, partner_company, period, sms, total, voice)
    SELECT
        account_group, description, direction, gprs, partner_company, period, sms, total, voice
        FROM dswtdip2_iot_da_dbo.triot_da_summary_outtap_cn_inssel;
END;
$procedure$
