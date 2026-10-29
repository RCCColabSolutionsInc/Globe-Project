CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_prepare_dp1_billed_error_pg(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    DELETE FROM dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_error_cache
        WHERE LOWER(billcycle) = LOWER(par_BillCycle);
    INSERT INTO dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, billcycle)
    WITH qu
    AS (SELECT
        ttinnove_billed.column01, ttinnove_billed.column02, ttinnove_billed.column03, ttinnove_billed.column04, ttinnove_billed.column05, ttinnove_billed.column06, ttinnove_billed.column07, ttinnove_billed.column08, ttinnove_billed.column09, ttinnove_billed.column10, ttinnove_billed.column11, ttinnove_billed.column12, ttinnove_billed.column13, ttinnove_billed.column14, ttinnove_billed.column15, ttinnove_billed.column16, ttinnove_billed.column17, ttinnove_billed.column18, ttinnove_billed.column19, ttinnove_billed.zdsp_order, ttinnove_billed.zdsp_uniquekey, par_BillCycle
        FROM dswtdir2_innove_dbo.ttinnove_billed
        INNER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
        /* [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x */
            ON LOWER(x.zdsp_uniquekey) = LOWER(ttinnove_billed.zdsp_uniquekey) AND LOWER(x.zdsp_order) = LOWER(ttinnove_billed.zdsp_order)
        WHERE (LOWER(ttinnove_billed.zlegacycycle_code) = LOWER(par_BillCycle)) AND (ttinnove_billed.zloaded = '0') AND LOWER(ttinnove_billed.column01) = LOWER('01') AND (LOWER(z_source_name) = LOWER('txInnove'))
        ORDER BY ttinnove_billed.column01 NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);
    /*
    SELECT TOP (100) PERCENT ttInnove_Billed.Column01,
    						ttInnove_Billed.Column02,
    						ttInnove_Billed.Column03,
    						ttInnove_Billed.Column04,
    						ttInnove_Billed.Column05,
    						ttInnove_Billed.Column06,
    						ttInnove_Billed.Column07,
    						ttInnove_Billed.Column08,
    						ttInnove_Billed.Column09,
    						ttInnove_Billed.Column10,
    						ttInnove_Billed.Column11,
    						ttInnove_Billed.Column12,
    						ttInnove_Billed.Column13,
    						ttInnove_Billed.Column14,
    						ttInnove_Billed.Column15,
    						ttInnove_Billed.Column16,
    						ttInnove_Billed.Column17,
    						ttInnove_Billed.Column18,
    						ttInnove_Billed.Column19,
    						ttInnove_Billed.zDSP_Order,
    						ttInnove_Billed.zDSP_UniqueKey,
    						@BillCycle
    FROM   dbo.ttInnove_Billed
    		INNER JOIN dbo.ZFFI_REPORT_ODBC_LATESTLOGS
    				ON ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY = ttInnove_Billed.zDSP_UniqueKey
    	AND ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER = ttInnove_Billed.ZDSP_ORDER
    WHERE  ( ttInnove_Billed.zLegacyCycle_Code = @BillCycle )
    		AND ( ttInnove_Billed.zLoaded = '0' )
    		AND ttInnove_Billed.Column01 = '01' AND (Z_SOURCE_NAME = 'txInnove' )
    ORDER  BY ttInnove_Billed.Column01
    */
END;
$procedure$
