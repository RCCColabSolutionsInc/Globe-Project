CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_count INT;
BEGIN
    -- =========================================================================
    -- 1. TARGET TABLE INITIALIZATION (Self-Healing)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.ttglobe_dp1_billed (
        zlegacydsp_order INT, zlegacycycle_code VARCHAR(5), data VARCHAR(50), 
        posting_date VARCHAR(50), sapfigl VARCHAR(50), ct VARCHAR(50), st VARCHAR(50), 
        ch_code VARCHAR(50), dp_code VARCHAR(50), amount VARCHAR(50), hits VARCHAR(50), 
        uom VARCHAR(50), wo_ind VARCHAR(50), cc VARCHAR(50), nb_ind VARCHAR(50), 
        brand VARCHAR(50), spa VARCHAR(50), rev_type VARCHAR(50), gl_code VARCHAR(50), 
        spb VARCHAR(50), remarks VARCHAR(255), zdsp_order VARCHAR(50), zdsp_uniquekey VARCHAR(255), 
        zactive INT, zsource VARCHAR(50), zduplicate INT, zloaded NUMERIC(1,0), 
        zload_message VARCHAR(500)
    );

    -- Inject Dummy Records if table is completely empty to allow independent testing
    SELECT COUNT(1) INTO v_count FROM dswtdir2_globe_dbo.ttglobe_dp1_billed;
    IF v_count = 0 THEN
        INSERT INTO dswtdir2_globe_dbo.ttglobe_dp1_billed (
            zlegacydsp_order, zlegacycycle_code, data, posting_date, sapfigl, ct, st, ch_code, dp_code, 
            amount, hits, uom, wo_ind, cc, nb_ind, brand, spa, rev_type, gl_code, spb, remarks, 
            zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        )
        SELECT 
            g.i, 'BC01', CASE WHEN g.i = 1 THEN '00' ELSE '01' END, '2026-05-05', 'SAPFIGL', 'CT', 'ST', 'CH_CODE', 'DP_CODE', 
            '100.00', '10', 'UOM', 'WO_IND', 'CC', 'NB_IND', 'GLOBE', 'SPA', 'REV_TYPE', 'GL_CODE', 'SPB', 'DUMMY POSTLOAD', 
            CAST(g.i AS VARCHAR), 'UNIQ_GLOBE_POSTLOAD_' || g.i, 1, 'TDIR2_Globe_DUMMY_POSTLOAD', 0, 0, ''
        FROM generate_series(1, 15) AS g(i);
        
        RAISE NOTICE 'Self-healed ttglobe_dp1_billed with 15 dummy records for Postload testing.';
    END IF;

    -- =========================================================================
    -- 2. ACTUAL POSTLOAD LOGIC (ODBC Validation)
    -- =========================================================================
    BEGIN
        -- Update Valid Records (zLoaded = 1)
        UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed xx 
        SET zloaded = 1
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_report_odbc yy
        WHERE CAST(xx.zdsp_order AS VARCHAR) = CAST(yy.zdsp_order AS VARCHAR)
          AND xx.zdsp_uniquekey = yy.zdsp_uniquekey
          AND yy.z_message NOT LIKE '%is not found%'
          AND yy.z_message NOT LIKE '%requires an assignment to a CO object%'
          AND yy.z_message NOT LIKE '%does not exist in chart of accounts%'
          AND yy.z_message NOT LIKE '%Error in document%'
          AND yy.z_message NOT LIKE '%not defined in chart of accounts%'
          AND yy.z_message NOT LIKE '%not allowed for characteristic%'
          AND yy.z_message NOT LIKE '%Balance in Transaction Currency%'
          AND xx.data = '01';

        -- Update Error Records (zLegacyCycle_Code = '0' for the entire cycle)
        WITH cte_witherrorsbillcycles AS (
            SELECT xx.zlegacycycle_code, COUNT(yy.z_message) AS error_count
            FROM dswtdir2_globe_dbo.ttglobe_dp1_billed xx
            INNER JOIN dgs4hana_tdir1_dbo.vw_rt_zffi_report_odbc yy
                ON CAST(xx.zdsp_order AS VARCHAR) = CAST(yy.zdsp_order AS VARCHAR) AND xx.zdsp_uniquekey = yy.zdsp_uniquekey
            WHERE (yy.z_message LIKE '%is not found%'
                OR yy.z_message LIKE '%requires an assignment to a CO object%'
                OR yy.z_message LIKE '%does not exist in chart of accounts%'
                OR yy.z_message LIKE '%Error in document%'
                OR yy.z_message LIKE '%not defined in chart of accounts%'
                OR yy.z_message LIKE '%not allowed for characteristic%'
                OR yy.z_message LIKE '%Balance in Transaction Currency%')
              AND xx.data = '01'
            GROUP BY xx.zlegacycycle_code
            HAVING COUNT(yy.z_message) > 0
        )
        UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed target
        SET zlegacycycle_code = '0'
        FROM cte_witherrorsbillcycles cte
        WHERE target.zlegacycycle_code = cte.zlegacycycle_code;

        RAISE NOTICE 'Globe Postload Transform executed successfully using actual ODBC view.';
    EXCEPTION WHEN OTHERS THEN
        -- =========================================================================
        -- 3. DUMMY FALLBACK (If ODBC View is missing during pipeline testing)
        -- =========================================================================
        UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed
        SET zloaded = 1
        WHERE zsource = 'TDIR2_Globe_DUMMY_POSTLOAD' AND CAST(zdsp_order AS INT) % 2 = 0;
        
        UPDATE dswtdir2_globe_dbo.ttglobe_dp1_billed
        SET zlegacycycle_code = '0'
        WHERE zsource = 'TDIR2_Globe_DUMMY_POSTLOAD' AND CAST(zdsp_order AS INT) % 2 <> 0;

        RAISE NOTICE 'ODBC View missing. Globe Postload Transform fell back to dummy data updates.';
    END;
END;
$procedure$
