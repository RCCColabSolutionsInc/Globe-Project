CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_subscriber()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca ("subscriber_type")
 		SELECT DISTINCT
        column05 AS "Subscriber Type"
        FROM dswtdir2_bayan_dbo.ttbayan_billed
        LEFT OUTER JOIN dswtdir2_bayan_dbo.zffi_subtype
        /* [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_SUBTYPE] -- dbo.ZFFI_SUBTYPE */
            ON LOWER(column05) = LOWER(zsubtype) AND (LOWER(zbukrs) = LOWER('BAYN')) AND LOWER(mandt) = LOWER('300')
        WHERE  (zsubtype IS NOT NULL);
-- 		AND (LOWER(column01) = LOWER('01'))
END;
$procedure$
