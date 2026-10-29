CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumintapcn_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 09/22/2022
Description: Insert Summary Intap CN into table
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.sumintapcn_table (account_group, description, direction, gp_cm_rm_gprs, gp_cm_rm_sms_out, gp_cm_rm_voice_o, gp_cm_total, gp_eg_rm_gprs, gp_eg_rm_sms_out, gp_eg_rm_voice_o, gp_eg_total, "GP_IBG-CONS_RM_GPRS", "GP_IBG-CONS_RM_SMS_OUT", "GP_IBG-CONS_RM_VOICE_O", "GP_IBG-CONS_TOTAL", gp_rm_gprs, gp_rm_sms_out, gp_rm_total, gp_rm_voice, gp_sg_rm_gprs, gp_sg_rm_sms_out, gp_sg_rm_voice_o, gp_sg_total, partner_company, period, pt_cm_rm_gprs, pt_cm_rm_sms_out, pt_cm_rm_voice_o, pt_cm_total, pt_eg_rm_gprs, pt_eg_rm_sms_out, pt_eg_rm_voice_o, pt_eg_total, pt_rm_gprs, pt_rm_sms_out, pt_rm_total, pt_rm_voice, pt_sg_rm_gprs, pt_sg_rm_sms_out, pt_sg_rm_voice_o, pt_sg_total, rm_gprs, rm_sms_out, rm_voice_o, sno, tm_cm_rm_gprs, tm_cm_rm_sms_out, tm_cm_rm_voice_o, tm_cm_total, tm_eg_rm_gprs, tm_eg_rm_sms_out, tm_eg_rm_voice_o, tm_eg_total, tm_rm_gprs, tm_rm_sms_out, tm_rm_total, tm_rm_voice_o, tm_sg_rm_gprs, tm_sg_rm_sms_out, tm_sg_rm_voice_o, tm_sg_total, total, total_adjustment)
    SELECT
        account_group, description, direction, gp_cm_rm_gprs, gp_cm_rm_sms_out, gp_cm_rm_voice_o, gp_cm_total, gp_eg_rm_gprs, gp_eg_rm_sms_out, gp_eg_rm_voice_o, gp_eg_total, "GP_IBG-CONS_RM_GPRS", "GP_IBG-CONS_RM_SMS_OUT", "GP_IBG-CONS_RM_VOICE_O", "GP_IBG-CONS_TOTAL", gp_rm_gprs, gp_rm_sms_out, gp_rm_total, gp_rm_voice, gp_sg_rm_gprs, gp_sg_rm_sms_out, gp_sg_rm_voice_o, gp_sg_total, partner_company, period, pt_cm_rm_gprs, pt_cm_rm_sms_out, pt_cm_rm_voice_o, pt_cm_total, pt_eg_rm_gprs, pt_eg_rm_sms_out, pt_eg_rm_voice_o, pt_eg_total, pt_rm_gprs, pt_rm_sms_out, pt_rm_total, pt_rm_voice, pt_sg_rm_gprs, pt_sg_rm_sms_out, pt_sg_rm_voice_o, pt_sg_total, rm_gprs, rm_sms_out, rm_voice_o, sno, tm_cm_rm_gprs, tm_cm_rm_sms_out, tm_cm_rm_voice_o, tm_cm_total, tm_eg_rm_gprs, tm_eg_rm_sms_out, tm_eg_rm_voice_o, tm_eg_total, tm_rm_gprs, tm_rm_sms_out, tm_rm_total, tm_rm_voice_o, tm_sg_rm_gprs, tm_sg_rm_sms_out, tm_sg_rm_voice_o, tm_sg_total, total, total_adjustment
        FROM dswtdip2_iot_da_dbo.triot_da_sumintapcn_inssel;
END;
$procedure$
