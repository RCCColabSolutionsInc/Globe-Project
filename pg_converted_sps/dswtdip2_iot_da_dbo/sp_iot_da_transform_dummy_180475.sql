CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- =========================================================================
    -- 1. MONTHLY SDR IB & OB (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_monthly_sdr_ib_ob (
        id INT, direction VARCHAR(10), sdr_amount NUMERIC(18,2), period VARCHAR(10)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_monthly_sdr_ib_ob;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_monthly_sdr_ib_ob (id, direction, sdr_amount, period)
    SELECT g.i, CASE WHEN g.i % 2 = 0 THEN 'IB' ELSE 'OB' END, 150.00, '2026-05' 
    FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 2. IB & OB USD SDR UPSIDE/DOWNSIDE (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_ib_ob_usd_sdr_upside_downside (
        id INT, direction VARCHAR(10), usd_amount NUMERIC(18,2), variance_type VARCHAR(20)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_ib_ob_usd_sdr_upside_downside;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_ib_ob_usd_sdr_upside_downside (id, direction, usd_amount, variance_type)
    SELECT g.i, 'IB', 500.25, 'UPSIDE' FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 3. SUMMARY HEADER IB & OB (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_header (
        id INT, header_name VARCHAR(100), total_count INT
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_header;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_header (id, header_name, total_count)
    SELECT g.i, 'SUMMARY_HEADER_' || g.i, 100 FROM generate_series(1, 5) AS g(i);

    -- =========================================================================
    -- 4. SUMMARY IB & OB USD (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_usd (
        id INT, summary_code VARCHAR(20), total_usd NUMERIC(18,2)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_usd;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_summary_ib_ob_usd (id, summary_code, total_usd)
    SELECT g.i, 'SUM_USD_' || g.i, 1250.50 FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 5. SUMMARY OUTTAP CN (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_summary_outtap_cn (
        id INT, cn_reference VARCHAR(50), cn_amount NUMERIC(18,2)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_summary_outtap_cn;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_summary_outtap_cn (id, cn_reference, cn_amount)
    SELECT g.i, 'OUTTAP_CN_REF_' || g.i, 300.00 FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 6. SUMMARY OUTTAP LOADFILE TABLE (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_summary_outtap_loadfile (
        id INT, loadfile_data VARCHAR(255), status VARCHAR(20)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_summary_outtap_loadfile;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_summary_outtap_loadfile (id, loadfile_data, status)
    SELECT g.i, 'OUTTAP_LOAD_DATA_' || g.i, 'PROCESSED' FROM generate_series(1, 15) AS g(i);

    -- =========================================================================
    -- 7. SUMMARY OUTTAP COPA SPLIT TOTAL (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_sumouttap_copa_split_total (
        id INT, copa_segment VARCHAR(50), split_amount NUMERIC(18,2)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_sumouttap_copa_split_total;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_sumouttap_copa_split_total (id, copa_segment, split_amount)
    SELECT g.i, 'COPA_SEG_' || g.i, 750.00 FROM generate_series(1, 5) AS g(i);

    -- =========================================================================
    -- 8. SUMMARY INTAP CN (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_sumintap_cn (
        id INT, cn_reference VARCHAR(50), cn_amount NUMERIC(18,2)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_sumintap_cn;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_sumintap_cn (id, cn_reference, cn_amount)
    SELECT g.i, 'INTAP_CN_REF_' || g.i, 420.00 FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 9. SUMMARY INTAP LOADFILE SDR (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile_sdr (
        id INT, sdr_data VARCHAR(255), sdr_value NUMERIC(18,2)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile_sdr;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile_sdr (id, sdr_data, sdr_value)
    SELECT g.i, 'INTAP_SDR_DATA_' || g.i, 99.99 FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 10. SUMMARY INTAP LOADFILE (Setup, Delete, Insert)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile (
        id INT, loadfile_data VARCHAR(255), status VARCHAR(20)
    );
    DELETE FROM dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile;
    INSERT INTO dswtdip2_iot_da_dbo.iot_da_sumintap_loadfile (id, loadfile_data, status)
    SELECT g.i, 'INTAP_LOAD_DATA_' || g.i, 'PROCESSED' FROM generate_series(1, 15) AS g(i);

    RAISE NOTICE 'ISMS IOT DA Transform (Dummy) executed successfully. All 10 target tables created, cleared, and populated with mock data.';

END;
$procedure$
