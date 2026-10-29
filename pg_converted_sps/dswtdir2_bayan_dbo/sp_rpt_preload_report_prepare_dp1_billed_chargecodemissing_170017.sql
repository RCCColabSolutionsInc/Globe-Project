CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_preload_report_prepare_dp1_billed_chargecodemissing()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    cur_missing_charge_code REFCURSOR;
BEGIN
    OPEN cur_missing_charge_code FOR
        SELECT c.missing_charge_code
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache AS c
        ORDER BY c.missing_charge_code;

	return ;
    -- Return the cursor to the caller
    -- The caller must fetch the results before committing.
END;

--CREATE OR REPLACE PROCEDURE
--    dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_chargecodemissing_ssrs()
--LANGUAGE plpgsql
--AS $procedure$
