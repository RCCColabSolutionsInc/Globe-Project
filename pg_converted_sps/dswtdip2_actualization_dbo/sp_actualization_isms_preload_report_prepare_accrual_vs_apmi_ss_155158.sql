CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_accrual_vs_apmi_ss(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "SAP CODE", "PARTNER CODE", doc_date, curr, invoice_hits, invoice_amount, books_hits, books_amount, difference_hits, difference_amount, hits_pt_cm_mt, hits_pt_eg_mt, hits_pt_sg_mt, hits_gp_cm_nbb, hits_gp_cm_mt, hits_gp_eg_mt, "HITS_GP_IBG-CONS_MT", hits_gp_sg_mt, hits_hy_cm_mt, hits_hy_eg_mt, "HITS_HY_IBG-CONS_MT", hits_hy_sg_mt, hits_tm_cm_mt, hits_total, hits_checking, amount_pt_cm_mt, amount_pt_eg_mt, amount_pt_sg_mt, amount_gp_cm_nbb, amount_gp_cm_mt, amount_gp_eg_mt, "AMOUNT_GP_IBG-CONS_MT", amount_gp_sg_mt, amount_hy_cm_mt, amount_hy_eg_mt, "AMOUNT_HY_IBG-CONS_MT", amount_hy_sg_mt, amount_tm_cm_mt, amount_total, amount_checking
        FROM dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_accrual_vs_apmi_cache;
END;
$procedure$
