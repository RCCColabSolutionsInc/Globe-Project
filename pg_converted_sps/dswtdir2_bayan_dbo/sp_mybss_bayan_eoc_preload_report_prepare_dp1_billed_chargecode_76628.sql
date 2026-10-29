CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_chargecode()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache;
	
   INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (missing_charge_code)
   SELECT DISTINCT
	    column06 AS missing_charge_code
	FROM dswtdir2_bayan_dbo.ttbayan_billed AS billed
	LEFT OUTER JOIN dswtdir2_bayan_dbo.zffi_0346 AS ffi
	    ON LOWER(TRIM(ffi.zccode)) = LOWER(TRIM(billed.column06))
	   AND LOWER(ffi.mandt) = LOWER('300')
	where ffi.zccode IS NULL and 1 = 0;

--AND
--LOWER(billed.column01) = LOWER('01');
--    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (missing_charge_code)
--    SELECT DISTINCT
--        column06 AS missing_charge_code
--        FROM dswtdir2_bayan_dbo.ttbayan_billed
--        LEFT OUTER JOIN dswtdir2_bayan_dbo.zffi_0346
--        /* [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_0346] -- dbo.ZFFI_0346 */
--            ON LOWER(LTRIM(RTRIM(zccode))) = LOWER(LTRIM(RTRIM(column06))) AND LOWER(mandt) = LOWER('300')
--        WHERE (LOWER(column01) = LOWER('01')) AND (zccode IS NULL);
END;
$procedure$
