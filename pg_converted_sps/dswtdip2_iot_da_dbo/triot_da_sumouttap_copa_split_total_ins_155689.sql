CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 09/22/2022
Modified by: Yash Raturi 09/22/2022
Description: Insert COPA SPlit into Table
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.sumouttap_copa_split_total_table (column1, gp_cm_rm_gprs, gp_cm_rm_sms_out, gp_cm_rm_voice_o, gp_cm_total, gp_eg_rm_gprs, gp_eg_rm_sms_out, gp_eg_rm_voice_o, gp_eg_total, "GP_IBG-CONS_RM_GPRS", "GP_IBG-CONS_RM_SMS_OUT", "GP_IBG-CONS_RM_VOICE_O", "GP_IBG-CONS_TOTAL", gp_sg_rm_gprs, gp_sg_rm_sms_out, gp_sg_rm_voice_o, gp_sg_total, partner_company, pt_cm_rm_gprs, pt_cm_rm_sms_out, pt_cm_rm_voice_o, pt_cm_total, pt_eg_rm_gprs, pt_eg_rm_sms_out, pt_eg_rm_voice_o, pt_eg_total, pt_sg_rm_gprs, pt_sg_rm_sms_out, pt_sg_rm_voice_o, pt_sg_total, sno, tm_cm_rm_gprs, tm_cm_rm_sms_out, tm_cm_rm_voice_o, tm_cm_total, tm_eg_rm_gprs, tm_eg_rm_sms_out, tm_eg_rm_voice_o, tm_eg_total, tm_sg_rm_gprs, tm_sg_rm_sms_out, tm_sg_rm_voice_o, tm_sg_total)
    SELECT
        column1, gp_cm_rm_gprs, gp_cm_rm_sms_out, gp_cm_rm_voice_o, gp_cm_total, gp_eg_rm_gprs, gp_eg_rm_sms_out, gp_eg_rm_voice_o, gp_eg_total, "GP_IBG-CONS_RM_GPRS", "GP_IBG-CONS_RM_SMS_OUT", "GP_IBG-CONS_RM_VOICE_O", "GP_IBG-CONS_TOTAL", gp_sg_rm_gprs, gp_sg_rm_sms_out, gp_sg_rm_voice_o, gp_sg_total, partner_company, pt_cm_rm_gprs, pt_cm_rm_sms_out, pt_cm_rm_voice_o, pt_cm_total, pt_eg_rm_gprs, pt_eg_rm_sms_out, pt_eg_rm_voice_o, pt_eg_total, pt_sg_rm_gprs, pt_sg_rm_sms_out, pt_sg_rm_voice_o, pt_sg_total, sno, tm_cm_rm_gprs, tm_cm_rm_sms_out, tm_cm_rm_voice_o, tm_cm_total, tm_eg_rm_gprs, tm_eg_rm_sms_out, tm_eg_rm_voice_o, tm_eg_total, tm_sg_rm_gprs, tm_sg_rm_sms_out, tm_sg_rm_voice_o, tm_sg_total
        FROM dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_inssel;
END;
$procedure$
