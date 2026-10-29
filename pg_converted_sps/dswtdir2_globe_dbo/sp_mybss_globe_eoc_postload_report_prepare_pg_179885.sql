CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_report_prepare_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
    v_recon_diff NUMERIC(38,2) := 0;
BEGIN
    -- Parameter mapping
    SELECT billcycle INTO v_billcycle FROM dswtdir2_globe_dbo.billcycles WHERE cyclecode = par_cyclecode;
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);


    CREATE TABLE IF NOT EXISTS sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis" (
        billcycle VARCHAR(5), column1 VARCHAR(100), column9 VARCHAR(50)
    );
    CREATE TABLE IF NOT EXISTS sdbtdir2_globe_dbo."318_Billed_Charges_ssis" (
        billcycle VARCHAR(5), column1 VARCHAR(100), column8 VARCHAR(50)
    );
    CREATE TABLE IF NOT EXISTS sdbtdir2_globe_dbo.sapglbilled_ssis (
        billcycle VARCHAR(5), column8 VARCHAR(50)
    );


    SELECT COALESCE(
        (
            -- Sum of Billed Charges
            (SELECT COALESCE(SUM(CAST(NULLIF(REPLACE(TRIM(column8), ',', ''), '') AS NUMERIC)), 0)
             FROM sdbtdir2_globe_dbo."318_Billed_Charges_ssis"
             WHERE billcycle = v_billcycle AND length(column1) = 1)
            +
            -- Sum of Billed Adjustments
            (SELECT COALESCE(SUM(CAST(NULLIF(REPLACE(TRIM(column9), ',', ''), '') AS NUMERIC)), 0)
             FROM sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis"
             WHERE billcycle = v_billcycle AND length(column1) = 1)
        ) 
        - 
        -- Sum of sapglbilled
        (SELECT COALESCE(SUM(CAST(NULLIF(REPLACE(TRIM(column8), ',', ''), '') AS NUMERIC)), 0)
         FROM sdbtdir2_globe_dbo.sapglbilled_ssis
         WHERE billcycle = v_billcycle), 
    0) INTO v_recon_diff;

    DROP TABLE IF EXISTS temp_postload_report;
    CREATE TEMP TABLE temp_postload_report AS
    SELECT 
        t.data,  
        t.posting_date AS date,  
        t.sapfigl AS brand,  
        t.ct AS customer_type,  
        t.st AS subscriber_type,  
        t.ch_code AS charge_code,  
        t.dp_code AS discount_code,  
        t.amount,  
        t.hits,  
        t.uom,  
        t.wo_ind AS wo_indicator,  
        t.cc AS cost_center,  
        ''::VARCHAR AS gl,  
        t.nb_ind AS nb_indicator,  
        t.remarks,  
        CAST(NULLIF(TRIM(CAST(t.zdsp_order AS VARCHAR)), '') AS INT) AS zdsp_order,  
        t.zdsp_uniquekey,  
        o.z_message AS posting_log_message,
        t.zloaded
    FROM dswtdir2_globe_dbo.ttglobe_dp1_billed t
    INNER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs o
        ON CAST(t.zdsp_order AS VARCHAR) = CAST(o.zdsp_order AS VARCHAR) 
        AND t.zdsp_uniquekey = o.zdsp_uniquekey
    WHERE t.zlegacycycle_code = v_billcycle

      AND v_recon_diff <= 100000.00 
      AND v_recon_diff >= -100000.00;

    DELETE FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache 
    WHERE billcycle = v_billcycle;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache (
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, v_billcycle
    FROM temp_postload_report
    WHERE CAST(zloaded AS INT) = 0
    ORDER BY data, zdsp_order;

    DELETE FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache 
    WHERE billcycle = v_billcycle;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache (
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, v_billcycle
    FROM temp_postload_report
    WHERE CAST(zloaded AS INT) = 1
    ORDER BY data, zdsp_order;

    RAISE NOTICE 'Postload Report Prepare executed successfully. Error and Valid caches updated for cycle %.', v_billcycle;
END;
$procedure$
