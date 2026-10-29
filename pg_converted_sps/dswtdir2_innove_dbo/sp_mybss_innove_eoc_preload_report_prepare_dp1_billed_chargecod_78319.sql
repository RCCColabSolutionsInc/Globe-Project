CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_chargecod()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    /* SELECT * INTO #ZFFI_0346  FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_0346]; */
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (missing_charge_code)
    SELECT DISTINCT
        column06 AS missing_charge_code
        FROM dswtdir2_innove_dbo.ttinnove_billed
        LEFT OUTER JOIN dswtdir2_innove_dbo.zffi_0346
        /* #ZFFI_0346 --[dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_0346]   -- dbo.ZFFI_0346 */
            ON LOWER(LTRIM(RTRIM(zccode))) = LOWER(LTRIM(RTRIM(column06))) AND LOWER(mandt) = LOWER('300')
        WHERE (LOWER(column01) = LOWER('01'))
AND (zccode IS NULL) and 1=0;

END;
$procedure$
