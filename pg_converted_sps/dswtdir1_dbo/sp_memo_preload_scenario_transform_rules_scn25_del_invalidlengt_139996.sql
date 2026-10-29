CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn25_del_invalidlengt()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 89 EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_InvalidLength_R2_Del] --Delete Invalid Length Records including entire counter - R2 Rule */
    WITH cte_srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invalidlength_r2_delsel_ssis
    AS (WITH qu
    AS (SELECT
        st.zscenario_scninitial, st.zcounter_scninitial, st.zcounterlineitem_scninitial, st.invoice_number, st.vendor_code, st.company_code, st.vat_code, st.gl_natural_code, st.currency, st.memoapp_ref_no_or_proponents_name, st.link_reference, st.link_ref_period, st.wbs_code, st.payment_terms, st.io_code, st.product_line, st.wht_type
        FROM dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS st
        WHERE st.zcounter_scninitial IN (SELECT
            bad_counters.zcounter_scninitial
            FROM dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS bad_counters
            INNER JOIN (
            /* zScenario_ScnInitial, zCounter_ScnInitial, zCounterLineItem_ScnInitial, */
            SELECT
                invoice_number, vendor_code, company_code
                /* , VAT_Code, WHT_Type, WHT_BASE,Gross_Invoice_Amount, Input_VAT_Amount, zInputFileName */
                /* From   stMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents */
                FROM sdbtdir1_memoapp_dbo.vw_memoapp_source_allproponents_ssis
                WHERE
                /* Len (zSAKNR_SKA1_ScnInitial) > '10' */
                /* OR Len (zTXT50_SKA1_ScnInitial) > '50' */
                /* OR */
                LENGTH(vendor_code) > '10' OR LENGTH(invoice_number) > '16' OR
                /* Len (Gross_Invoice_Amount) > '13' OR */
                LENGTH(vat_code) > '2' OR LENGTH(gl_natural_code) > '10' OR
                /* Len (Input_VAT_Amount) > '13' OR */
                LENGTH(company_code) > '4' OR LENGTH(gl_natural_code) > '10' OR LENGTH(currency) > '5' OR LENGTH(memoapp_ref_no_or_proponents_name) > '25' OR LENGTH(link_reference) > '12' OR LENGTH(link_ref_period) > '12' OR LENGTH(wbs_code) > '24' OR LENGTH(payment_terms) > '4' OR LENGTH(io_code) > '12' OR LENGTH(product_line) > '10' OR
                /* Len (WHT_BASE) > '13' OR */
                LENGTH(wht_type) > '2')
            /* OR LEFT(Ltrim(Rtrim(Invoice_date)), 10) Like '% %'  '2021/01/28(Roshiel) - Revert the docdate filter */
            AS bad_data
                ON bad_counters.invoice_number = bad_data.invoice_number AND bad_counters.vendor_code = bad_data.vendor_code AND bad_counters.company_code = bad_data.company_code)
        ORDER BY st.invoice_number NULLS FIRST, st.vendor_code NULLS FIRST, st.company_code NULLS FIRST, st.zscenario_scninitial NULLS FIRST, st.zcounter_scninitial NULLS FIRST, st.zcounterlineitem_scninitial NULLS FIRST, st.vat_code NULLS FIRST, st.gl_natural_code NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * 100 / 100))
    /* --Please change the report as well - Invalid length in lineitem, and Invalid length in counter. */
    DELETE FROM cte_srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invalidlength_r2_delsel_ssis;
END;
$procedure$
