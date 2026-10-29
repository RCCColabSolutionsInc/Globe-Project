CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/22/2021
Modified by: Pradeep Gupta 04/05/2021
Description: Inserting IDD data
*/
BEGIN
    INSERT INTO dswtdir3_aprm_dbo.prev_mon_analysis_per_partner ("CHARGE DIRECTION", currency, month, service, "Sum of NET SETTABLE AMT", "Sum of SETTABLE DURATION", type)
    SELECT
        "CHARGE DIRECTION", currency, month, service, "Sum of NET SETTABLE AMT", "Sum of SETTABLE DURATION", type
        FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerinssel;
END;
$procedure$
