CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_prepare_dp1_billed_valid(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    DELETE FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache
        WHERE LOWER(billcycle) = LOWER(par_BillCycle);
    
	INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, posting_log_message, billcycle)
    WITH qu
    AS (
		SELECT DISTINCT
		ttbayan_billed.column01, ttbayan_billed.column02, ttbayan_billed.column03, ttbayan_billed.column04, ttbayan_billed.column05, 
		ttbayan_billed.column06, ttbayan_billed.column07, ttbayan_billed.column08, ttbayan_billed.column09, ttbayan_billed.column10, 
		ttbayan_billed.column11, ttbayan_billed.column12, ttbayan_billed.column13, ttbayan_billed.column14, ttbayan_billed.column15, 
		ttbayan_billed.column16, ttbayan_billed.column17, ttbayan_billed.column18, ttbayan_billed.column19,
			CASE
	        	WHEN LOWER(column01) <> LOWER('01') THEN NULL
	            ELSE ttbayan_billed.zdsp_order
	        END AS  par_BillCycle
		FROM dswtdir2_bayan_dbo.ttbayan_billed
        LEFT OUTER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x ON LOWER(x.zdsp_uniquekey) = LOWER(ttbayan_billed.zdsp_uniquekey) AND LOWER(x.zdsp_order) = LOWER(ttbayan_billed.zdsp_order)
        WHERE (LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycle)) AND (ttbayan_billed.zloaded = '1') AND (LOWER(z_source_name) = LOWER('txBayan')) OR (LOWER(column01) IN (LOWER('00'), LOWER('99')) AND LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycle))
        ORDER BY ttbayan_billed.column01 NULLS FIRST)

--		SELECT DISTINCT
--        ttbayan_billed.column01, ttbayan_billed.column02, ttbayan_billed.column03, ttbayan_billed.column04, ttbayan_billed.column05, ttbayan_billed.column06, ttbayan_billed.column07, ttbayan_billed.column08, ttbayan_billed.column09, ttbayan_billed.column10, ttbayan_billed.column11, ttbayan_billed.column12, ttbayan_billed.column13, ttbayan_billed.column14, ttbayan_billed.column15, ttbayan_billed.column16, ttbayan_billed.column17, ttbayan_billed.column18, ttbayan_billed.column19,
--        CASE
--            WHEN LOWER(column01) <> LOWER('01') THEN NULL
--            ELSE ttbayan_billed.zdsp_order
--        END AS zdsp_order, ttbayan_billed.zdsp_uniquekey, z_message AS posting_log_message, par_BillCycle
--        FROM dswtdir2_bayan_dbo.ttbayan_billed
--        LEFT OUTER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
--        /* [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x -- dbo.ZFFI_REPORT_ODBC_LATESTLOGS */
--            ON LOWER(x.zdsp_uniquekey) = LOWER(ttbayan_billed.zdsp_uniquekey) AND LOWER(x.zdsp_order) = LOWER(ttbayan_billed.zdsp_order)
--        WHERE (LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycle)) AND (ttbayan_billed.zloaded = '1') AND (LOWER(z_source_name) = LOWER('txBayan')) OR (LOWER(column01) IN (LOWER('00'), LOWER('99')) AND LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycl))
--        ORDER BY ttbayan_billed.column01 NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);

--INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, posting_log_message, billcycle)
--    WITH qu
--    AS (SELECT DISTINCT
--        ttbayan_billed.column01, ttbayan_billed.column02, ttbayan_billed.column03, ttbayan_billed.column04, ttbayan_billed.column05, ttbayan_billed.column06, ttbayan_billed.column07, ttbayan_billed.column08, ttbayan_billed.column09, ttbayan_billed.column10, ttbayan_billed.column11, ttbayan_billed.column12, ttbayan_billed.column13, ttbayan_billed.column14, ttbayan_billed.column15, ttbayan_billed.column16, ttbayan_billed.column17, ttbayan_billed.column18, ttbayan_billed.column19,
--        CASE
--            WHEN LOWER(column01) <> LOWER('01') THEN NULL
--            ELSE ttbayan_billed.zdsp_order
--        END AS zdsp_order, ttbayan_billed.zdsp_uniquekey, z_message AS posting_log_message, par_BillCycle
--        FROM dswtdir2_bayan_dbo.ttbayan_billed
--        LEFT OUTER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
--        /* [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x -- dbo.ZFFI_REPORT_ODBC_LATESTLOGS */
--            ON LOWER(x.zdsp_uniquekey) = LOWER(ttbayan_billed.zdsp_uniquekey) AND LOWER(x.zdsp_order) = LOWER(ttbayan_billed.zdsp_order)
--        WHERE (LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycle)) AND (ttbayan_billed.zloaded = '1') AND (LOWER(z_source_name) = LOWER('txBayan')) OR (LOWER(column01) IN (LOWER('00'), LOWER('99')) AND LOWER(ttbayan_billed.zlegacycycle_code) = LOWER(par_BillCycle))
--        ORDER BY ttbayan_billed.column01 NULLS FIRST)
--    SELECT
--        *
--        FROM qu
--        LIMIT ((SELECT
--            count(*)
--            FROM qu) * (100) / 100);
END;
$procedure$
