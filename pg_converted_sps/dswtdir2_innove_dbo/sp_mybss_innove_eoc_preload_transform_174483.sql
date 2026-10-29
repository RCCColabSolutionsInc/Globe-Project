CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_transform(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN

    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- Establishes configuration lookup data across the pipeline dynamically
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10),
        billcycle VARCHAR(5),
        description VARCHAR(50),
        runday INT,
        keyword_ssrs VARCHAR(20),
        exportfilekey VARCHAR(100),
        exportfilename VARCHAR(100)
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
    SELECT billcycle INTO v_billcycle 
    FROM dswtdir2_innove_dbo.billcycles 
    WHERE cyclecode = par_cyclecode;

    -- =========================================================================
    -- 1. CLEAR AND INSERT STAGING DATA
    -- =========================================================================
    DELETE FROM dswtdir2_innove_dbo.stinnove_billed_tdir2_innove_sapglbilled 
    WHERE cycle_code = v_billcycle;

    INSERT INTO dswtdir2_innove_dbo.stinnove_billed_tdir2_innove_sapglbilled (
        cycle_code, zrownumber, column1, column2, column3, column4, column5, 
        column6, column7, column8, column9, column10, column11, column12, 
        column13, column14, column15, column16, column17, column18, column19
    )
    SELECT
        x.billcycle, x.rownumber, x.column1, x.column2, x.column3, x.column4, 
        x.column5, x.column6, x.column7,
        CAST(CAST(NULLIF(TRIM(x.column8), '') AS NUMERIC(18,2)) AS VARCHAR(50)),
        CAST(CAST(NULLIF(TRIM(x.column9), '') AS NUMERIC(18,2)) AS VARCHAR(50)),
        x.column10, x.column11, x.column12, x.column13, x.column14, x.column15, 
        x.column16, x.column17, x.column18, x.column19
    FROM sdbtdir2_innove_dbo.sap_glbilled_ssis x
    WHERE x.billcycle = v_billcycle
    ORDER BY x.billcycle, x.rownumber;

    -- =========================================================================
    -- 2. IMPLEMENT SOURCE RULES (Nested Procedures)
    -- =========================================================================
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zlegacycycle_codeupd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zlegacydsp_orderupd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zdsp_orderupd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn01upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn02upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn03upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn04upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn05upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn06upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn07upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn08upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn09upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn10upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn11upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn12upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn13upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn14upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn15upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn16upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn17upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn18upd();
    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn19upd();

    -- Sync batch number
    UPDATE dswtdir2_innove_dbo.stinnove_billed_tdir2_innove_sapglbilled x
    SET zcolumn05 = CAST(CAST(y.batch_no AS INT) + 1 AS VARCHAR)
    FROM dswtdir2_innove_dbo.ztf0001s y
    WHERE x.column2 = y.from_system 
      AND x.column3 = y.to_system 
      AND x.column4 = y.event  
      AND x.column1 = '00' 
      AND y.bukrs = 'INOV' 
      AND x.zlegacycycle_code = v_billcycle;

    CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zdsp_uniquekeyupd();

    -- =========================================================================
    -- 3. TARGET INSERT (Push to Main Table)
    -- =========================================================================
    DELETE FROM dswtdir2_innove_dbo.ttinnove_billed 
    WHERE zsource = 'TDIR2_Innove' AND zlegacycycle_code = v_billcycle;

    INSERT INTO dswtdir2_innove_dbo.ttinnove_billed (
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, 
        column05, column06, column07, column08, column09, column10, column11, column12, 
        column13, column14, column15, column16, column17, column18, column19, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
    )
    SELECT 
        zlegacydsp_order, zlegacycycle_code, zcolumn01, zcolumn02, zcolumn03, zcolumn04, 
        zcolumn05, zcolumn06, zcolumn07, zcolumn08, zcolumn09, zcolumn10, zcolumn11, zcolumn12, 
        zcolumn13, zcolumn14, zcolumn15, zcolumn16, zcolumn17, zcolumn18, zcolumn19, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message 
    FROM dswtdir2_innove_dbo.stinnove_billed_tdir2_innove_sapglbilled 
    WHERE zlegacycycle_code = v_billcycle;

    -- =========================================================================
    -- 4. IMPLEMENT TARGET RULES
    -- =========================================================================
    
    -- Flag loaded(posted) and not for posting based on SAP message
    UPDATE dswtdir2_innove_dbo.ttinnove_billed tt
    SET zloaded = '1'
    FROM dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs odbc
    WHERE tt.zdsp_order = odbc.zdsp_order
      AND tt.zdsp_uniquekey = odbc.zdsp_uniquekey
      AND odbc.z_message NOT LIKE '%does not exist for%'
      AND odbc.z_message NOT LIKE '%is not allowed for characteristic%'
      AND odbc.z_message NOT LIKE '%requires an assignment to a CO object%'
      AND odbc.z_message NOT LIKE '%Error in document%'
      AND odbc.z_message NOT LIKE '%is not found in table%'
      AND tt.column01 = '01'
      AND tt.zlegacycycle_code = v_billcycle;

    -- Ensures that cycle with errors is not flagged as loaded
    WITH cte_billcyclewitherror AS (
        SELECT tt.zlegacycycle_code, COUNT(odbc.z_message) AS error_count 
        FROM dswtdir2_innove_dbo.ttinnove_billed tt
        INNER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs odbc
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
    SET zloaded = '0'
    FROM cte_billcyclewitherror xx
    WHERE xx.zlegacycycle_code = tt.zlegacycycle_code;

END;
$procedure$
