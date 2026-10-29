CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_todo()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Accrual_vs_APMI] */
    /* - tvActualization_ISMS_ACCRUALVSAPMI_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_APMI] */
    /* - tvActualization_ISMS_APMI_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_IB_OB_PreControl] */
    /* - tvActualization_ISMS_IB_OB_PreControlRptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Inbound_Outbound_Adjustment */
    /* - tvActualization_ISMS_INBOUND_OUTBOUND_Adjustment_Preload_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Invoices_Summary_GT3%Var_Approval] */
    /* - tvActualization_ISMS_SummaryOfInvoices_ThresholdGT3%Variances_ForApprovalRptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Summary_vs_Accrual_Inbound] */
    /* - tvActualization_ISMS_SUMMARYVSACCRUAL_INBOUND_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Summary_vs_Accrual] */
    /* - tvActualization_ISMS_SummaryVSAccrual_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_Validation] */
    /* - tvActualization_ISMS_Validation_RptSel */
    /* EXEC [dbo].[sp_Actualization_ISMS_Preload_Report_Prepare_OpenBal_LoadFile] */
    /* - tvActualization_ISMS_ZF_OPENBAL_LoadFile_RptSel */
    BEGIN
    END;
END;
$procedure$
