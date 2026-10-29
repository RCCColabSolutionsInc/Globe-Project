CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_transform(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- PARAMETER SAFEGUARD (Bulletproofing)
    -- =========================================================================
    IF par_cyclecode ~ '^[0-9]+$' THEN
        par_cyclecode := 'BC' || LPAD(par_cyclecode, 2, '0');
    END IF;

    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_globe_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txGlobe_Billed_Cycle2_LoadFileSel', 'txGlobe_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txGlobe_Billed_Cycle3_LoadFileSel', 'txGlobe_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txGlobe_Billed_Cycle4_LoadFileSel', 'txGlobe_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txGlobe_Billed_Cycle5_LoadFileSel', 'txGlobe_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txGlobe_Billed_Cycle6_LoadFileSel', 'txGlobe_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txGlobe_Billed_Cycle7_LoadFileSel', 'txGlobe_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txGlobe_Billed_Cycle8_LoadFileSel', 'txGlobe_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txGlobe_Billed_Cycle9_LoadFileSel', 'txGlobe_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txGlobe_Billed_Cycle10_LoadFileSel', 'txGlobe_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txGlobe_Billed_Cycle11_LoadFileSel', 'txGlobe_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_globe_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    SELECT billcycle INTO v_billcycle FROM dswtdir2_globe_dbo.billcycles WHERE cyclecode = par_cyclecode;
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);

    -- =========================================================================
    -- 1. CLEAR AND LOAD INITIAL STAGING TABLE
    -- =========================================================================
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp1_billed_tdir2_globe_saplbilled 
    WHERE cycle_code = v_billcycle;

    INSERT INTO dswtdir2_globe_dbo.stglobe_dp1_billed_tdir2_globe_saplbilled (
        cycle_code, zrownumber, column1, column2, column3, column4, column5, 
        column6, column7, column8, column9, column10
    )
    SELECT
        x.billcycle,
        x.rownumber,
        x.column1,
        x.column2,
        x.column3,
        x.column4,
        x.column5,
        x.column6,
        x.column7,
        CAST(CAST(x.column8 AS DECIMAL(18,2)) AS VARCHAR(50)),
        CAST(CAST(x.column9 AS DECIMAL(18,2)) AS VARCHAR(50)),
        x.column10
    FROM sdbtbdir2_globe_dbo.sapglbilled_ssis x
    WHERE x.billcycle = v_billcycle
    ORDER BY x.billcycle, x.rownumber;

    -- =========================================================================
    -- 2. IMPLEMENT SOURCE RULES (Dynamic Sub-Procedure Calls)
    -- =========================================================================
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zlegacycycle_codeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zlegacydsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdataupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zposting_dateupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zsapfiglupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zctupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zstupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zch_codeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdp_codeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zamountupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zhitsupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zuomupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zbrandupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zspaupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zspa_rule2upd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zrev_typeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zgl_codeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zspbupd();
    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zremarksupd();

    -- Batch Number Sync (Ported from Legacy)
    UPDATE dswtdir2_globe_dbo.stglobe_dp1_billed_tdir2_globe_saplbilled x
    SET zst = CAST(CAST(y.batch_no AS INT) + 1 AS VARCHAR)
    FROM dswtdir2_globe_dbo.ztf0001s y
    WHERE x.column2 = y.from_system  
      AND x.column3 = y.to_system  
      AND x.column4 = y.event  
      AND x.column1 = '00'
      AND y.bukrs = 'GLOB'
      AND x.zlegacycycle_code = v_billcycle;

    CALL dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdsp_uniquekeyupd();

    -- =========================================================================
    -- 3. TARGET TABLE INSERT
    -- =========================================================================
    DELETE FROM dswtdir2_globe_dbo.ttglobe_dp1_billed 
    WHERE zsource = 'TDIR2_Globe' AND zlegacycycle_code = v_billcycle;

    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp1_billed (
        zlegacydsp_order, zlegacycycle_code, data, posting_date, sapfigl, ct, st, ch_code, dp_code, 
        amount, hits, uom, wo_ind, cc, nb_ind, brand, spa, rev_type, gl_code, spb, remarks, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
    )
    SELECT 
        zlegacydsp_order, zlegacycycle_code, zdata, zposting_date, zsapfigl, zct, zst, zch_code, zdp_code, 
        zamount, zhits, zuom, zwo_ind, zcc, znb_ind, zbrand, zspa, zrev_type, zgl_code, zspb, zremarks, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message 
    FROM dswtdir2_globe_dbo.stglobe_dp1_billed_tdir2_globe_saplbilled 
    WHERE zlegacycycle_code = v_billcycle;

    -- =========================================================================
    -- 4. TARGET RULES (ODBC Log Validation)
    -- =========================================================================
    
    -- Flag Valid Records
    UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed xx 
    SET zloaded = 1
    FROM dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs yy
    WHERE xx.zdsp_order = yy.zdsp_order
      AND xx.zdsp_uniquekey = yy.zdsp_uniquekey
      AND yy.z_message NOT LIKE '%is not found%'
      AND yy.z_message NOT LIKE '%requires an assignment to a CO object%'
      AND yy.z_message NOT LIKE '%does not exist in chart of accounts%'
      AND yy.z_message NOT LIKE '%Error in document%'
      AND yy.z_message NOT LIKE '%not defined in chart of accounts%'
      AND yy.z_message NOT LIKE '%not allowed for characteristic%'
      AND yy.z_message NOT LIKE '%Balance in Transaction Currency%'
      AND yy.z_message NOT LIKE '%Header Control on Amount is Invalid%'
      AND xx.data = '01'
      AND xx.zlegacycycle_code = v_billcycle;

    -- Flag Error Records (CTE converted to native Update)
    WITH cte_witherrorsbillcycles AS (
        SELECT xx.zlegacycycle_code, COUNT(yy.z_message) AS error_count
        FROM dswtdir2_globe_dbo.ttglobe_dp1_billed xx
        INNER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs yy
            ON xx.zdsp_order = yy.zdsp_order AND xx.zdsp_uniquekey = yy.zdsp_uniquekey
        WHERE (yy.z_message LIKE '%is not found%'
            OR yy.z_message LIKE '%requires an assignment to a CO object%'
            OR yy.z_message LIKE '%does not exist in chart of accounts%'
            OR yy.z_message LIKE '%Error in document%'
            OR yy.z_message LIKE '%not defined in chart of accounts%'
            OR yy.z_message LIKE '%not allowed for characteristic%'
            OR yy.z_message LIKE '%Balance in Transaction Currency%'
            OR yy.z_message LIKE '%Header Control on Amount is Invalid%')
          AND xx.data = '01'
          AND xx.zlegacycycle_code = v_billcycle
        GROUP BY xx.zlegacycycle_code
        HAVING COUNT(yy.z_message) > 0
    )
    UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed target
    SET zloaded = 0
    FROM cte_witherrorsbillcycles cte
    WHERE target.zlegacycycle_code = cte.zlegacycycle_code;

END;
$procedure$
