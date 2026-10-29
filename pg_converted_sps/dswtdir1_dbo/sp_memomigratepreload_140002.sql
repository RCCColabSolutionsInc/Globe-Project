CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memomigratepreload(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_dt DATE DEFAULT clock_timestamp();
BEGIN
    CREATE TEMPORARY TABLE t$temp
    (orderno INTEGER,
        process VARCHAR(40),
        dateprocessed DATE,
        processname VARCHAR(500),
        recordcount INTEGER);
    INSERT INTO t$temp
    SELECT
        1 AS seq, 'Preload', var_dt AS processeddate, 'srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_InvalidLength_R2_Delsel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invalidlength_r2_delsel
    UNION ALL
    SELECT
        2 AS seq, 'Preload', var_dt AS processeddate, 'ttMEMOAPP_Preload' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.ttmemoapp_preload
    UNION ALL
    SELECT
        3 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario1_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario1_without_taxcodesel
    UNION ALL
    SELECT
        4 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario2To5_With_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario2to5_with_taxcodesel
    UNION ALL
    SELECT
        5 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario2To5_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario2to5_without_taxcodesel
    UNION ALL
    SELECT
        6 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario6_Accrual2To5A_AccrualReversalSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5a_accrualreversalsel
    UNION ALL
    SELECT
        7 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario6_Accrual2To5B_NewAccDoc_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5b_newaccdoc_without_taxcodesel
    UNION ALL
    SELECT
        8 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario6_Accrual2To5C_Invoice_With_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5c_invoice_with_taxcodesel
    UNION ALL
    SELECT
        9 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario6_Accrual2To5C_Invoice_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5c_invoice_without_taxcodesel
    UNION ALL
    SELECT
        10 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario8M_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario8m_without_taxcodesel
    UNION ALL
    SELECT
        11 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario8R_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario8r_without_taxcodesel
    UNION ALL
    SELECT
        12 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario9_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario9_without_taxcodesel
    UNION ALL
    SELECT
        13 AS seq, 'Preload', var_dt AS processeddate, 'txMEMOAPP_Preload_OpenBal_Scenario10_WithOut_TaxCodeSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario10_without_taxcodesel
    UNION ALL
    SELECT
        14 AS seq, 'Preload', var_dt AS processeddate, 'trMEMOAPP_DCS_Preload_PreloadError_Insert_Into_DcMemoApp_InsSel' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.trmemoapp_dcs_preload_preloaderror_insert_into_dcmemoapp_inssel;
    INSERT INTO t$temp
    SELECT
        15, 'Preload', var_dt, 'Preload x Line Items Discrepancy', (SELECT
            recordcount
            FROM t$temp AS xx
            WHERE xx.orderno = 2) - (SELECT
            SUM(recordcount)
            FROM t$temp AS x
            WHERE x.orderno BETWEEN 3 AND 14);
    OPEN p_refcur FOR
    SELECT
        *
        FROM t$temp;
    /*
    
    DROP TABLE IF EXISTS t$temp;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
