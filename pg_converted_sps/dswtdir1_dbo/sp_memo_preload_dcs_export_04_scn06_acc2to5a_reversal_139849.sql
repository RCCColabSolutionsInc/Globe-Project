CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_export_04_scn06_acc2to5a_reversal(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        'Accrual_Doc_Number', 'Company_code', 'Accrual_Doc_Fiscal_Year', 'zDSP_Order', 'zDSP_UniqueKey'
    UNION ALL
    SELECT
        accrual_doc_number, company_code, CAST (accrual_doc_fiscal_year AS VARCHAR(255)) AS accrual_doc_fiscal_year, zdsp_order, zdsp_uniquekey
        FROM dswtdir1_dbo.txmemoapp_dcs_output_fromdcs_cleanseddata_openbal_scenario6_accrual2to5a_accrualreversalsel;
END;
$procedure$
