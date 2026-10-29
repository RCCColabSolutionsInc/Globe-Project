CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 04/05/2021
Modified by: Pradeep Gupta 04/05/2021
Description: Inserting  IDD Detailed per partner data
*/
BEGIN
    INSERT INTO dswtdir3_aprm_dbo.prev_mon_analysis_per_partner_det ("CHARGE DIRECTION", currency, "INTERCONNECT PARTNER NAME", month, "SAP VENDOR CODE", service, "Sum of NET SETTABLE AMT", "Sum of SETTABLE DURATION", type)
    SELECT
        "CHARGE DIRECTION", currency, "INTERCONNECT PARTNER NAME", month, "SAP VENDOR CODE", service, "Sum of NET SETTABLE AMT", "Sum of SETTABLE DURATION", type
        FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detinssel;
END;
$procedure$
