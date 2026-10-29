CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pmdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 03/17/2021
Modified by: Debojit Roy 03/17/2021
Description: Deletes Previous Month data
*/
BEGIN
    DELETE FROM dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pmdelsel;
END;
$procedure$
