CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_transform(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_innove_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txInnove_Billed_Cycle2_LoadFileSel', 'txInnove_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txInnove_Billed_Cycle3_LoadFileSel', 'txInnove_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txInnove_Billed_Cycle4_LoadFileSel', 'txInnove_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txInnove_Billed_Cycle5_LoadFileSel', 'txInnove_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txInnove_Billed_Cycle6_LoadFileSel', 'txInnove_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txInnove_Billed_Cycle7_LoadFileSel', 'txInnove_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txInnove_Billed_Cycle8_LoadFileSel', 'txInnove_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txInnove_Billed_Cycle9_LoadFileSel', 'txInnove_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txInnove_Billed_Cycle10_LoadFileSel', 'txInnove_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txInnove_Billed_Cycle11_LoadFileSel', 'txInnove_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_innove_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    -- Resolve BillCycle from CycleCode
    SELECT billcycle INTO v_billcycle FROM dswtdir2_innove_dbo.billcycles WHERE cyclecode = par_cyclecode;
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);

    -- =========================================================================
    -- POSTLOAD TARGET RULES 
    -- Merges trInnove_Billed_zloaded_Upd and trInnove_Billed_zLoaded_0_CycleCodeUpd
    -- =========================================================================
    
    -- 1. Flag records as successfully loaded (zLoaded = 1) if SAP ODBC logs indicate no specific errors
    UPDATE dswtdir2_innove_dbo.ttinnove_billed tt
    SET zloaded = 1
    FROM dgs4hana_tdir1_dbo.vw_rt_zffi_report_odbc odbc
    WHERE tt.zdsp_order = odbc.zdsp_order
      AND tt.zdsp_uniquekey = odbc.zdsp_uniquekey
      AND odbc.z_message NOT LIKE '%does not exist for%'
      AND odbc.z_message NOT LIKE '%is not allowed for characteristic%'
      AND odbc.z_message NOT LIKE '%requires an assignment to a CO object%'
      AND odbc.z_message NOT LIKE '%Error in document%'
      AND odbc.z_message NOT LIKE '%is not found in table%'
      AND tt.column01 = '01'
      AND tt.zlegacycycle_code = v_billcycle;

    -- 2. Fallback: If ANY record in the cycle has an error, flag the ENTIRE cycle as not loaded (zLoaded = 0)
    WITH cte_billcyclewitherror AS (
        SELECT tt.zlegacycycle_code, COUNT(odbc.z_message) AS error_count 
        FROM dswtdir2_innove_dbo.ttinnove_billed tt
        INNER JOIN dgs4hana_tdir1_dbo.vw_rt_zffi_report_odbc odbc
            ON tt.zdsp_order = odbc.zdsp_order AND tt.zdsp_uniquekey = odbc.zdsp_uniquekey  
        WHERE (odbc.z_message LIKE '%does not exist for%'
           OR odbc.z_message LIKE '%is not allowed for characteristic%'
           OR odbc.z_message LIKE '%requires an assignment to a CO object%'
           OR odbc.z_message LIKE '%Error in document%'
           OR odbc.z_message LIKE '%is not found in table%')  
          AND tt.column01 = '01'
          AND tt.zlegacycycle_code = v_billcycle
        GROUP BY tt.zlegacycycle_code  
        HAVING COUNT(odbc.z_message) > 0
    )
    UPDATE dswtdir2_innove_dbo.ttinnove_billed tt
    SET zloaded = 0
    FROM cte_billcyclewitherror xx
    WHERE xx.zlegacycycle_code = tt.zlegacycycle_code;

END;
$procedure$
