CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_postload_error_ssrs_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5) := par_cyclecode;
BEGIN
    -- =========================================================================
    -- SSRS REPORT FETCH SIMULATION
    -- Since this is called via JDBC {call proc_name(?)}, we cannot return a 
    -- raw SELECT. Instead, we dump the report output into a physical dummy table.
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdir2_bayan_dbo.rpt_postload_error_ssrs_out_dmy;
    
    CREATE TABLE dswtdir2_bayan_dbo.rpt_postload_error_ssrs_out_dmy AS
    SELECT 
        c.column01, c.column02, c.column03, c.column04, c.column05, 
        c.column06, c.column07, c.column08, c.column09, c.column10, 
        c.column11, c.column12, c.column13, c.column14, c.column15, 
        c.column16, c.column17, c.column18, c.column19, 
        c.zdsp_order, c.zdsp_uniquekey, c.billcycle
    FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache_dummy c
    WHERE c.billcycle = v_billcycle
    ORDER BY c.column01, NULLIF(c.zdsp_order, '')::INT;

    RAISE NOTICE 'SSRS Error Report procedure executed successfully via CALL. Data staged in rpt_postload_error_ssrs_out_dmy.';
END;
$procedure$
