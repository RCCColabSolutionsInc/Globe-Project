CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_manual_rep(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    -- Clear the cache table for the current bill cycle
    DELETE FROM dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_manualreport_cache
    WHERE LOWER(TRIM(billcycle)) = LOWER(TRIM(par_billcycle));

    -- Direct INSERT using a CTE
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_manualreport_cache (
        zlegacydsp_order, data, "Posting Date", sapfigl, "Customer Type", 
        "Subscriber Type", "Charge Code", "Discount Code", amount, hits, 
        uom, brand, spa, "Rev Type", gl, spb, remarks, billcycle
    )
    WITH qu AS (
        SELECT
            zlegacydsp_order,
            data AS data,
            posting_date AS "Posting Date",
            sapfigl AS sapfigl,
            ct AS "Customer Type",
            st AS "Subscriber Type",
            ch_code AS "Charge Code",
            dp_code AS "Discount Code",
            amount AS amount,
            hits AS hits,
            uom AS uom,
            brand AS brand,
            spa AS spa,
            rev_type AS "Rev Type",
            gl_code AS gl,
            spb AS spb,
            remarks AS remarks
        FROM dswtdir2_globe_dbo.ttglobe_dp1_billed
        WHERE TRIM(data) IN ('01', '1') 
          AND LOWER(TRIM(zlegacycycle_code)) = LOWER(TRIM(par_billcycle))
    )
    SELECT
        zlegacydsp_order, data, "Posting Date", sapfigl, "Customer Type", 
        "Subscriber Type", "Charge Code", "Discount Code", amount, hits, 
        uom, brand, spa, "Rev Type", gl, spb, remarks, par_billcycle
    FROM qu;

END;
$procedure$
