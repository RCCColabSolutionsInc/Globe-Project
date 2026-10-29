CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: Transform postload data */
/* ============================================= */
BEGIN
    /* Original implementation */
    CALL dswtdir2_globe_dbo.trglobe_dp1_billed_zloaded_0_cyclecodeupd();
    CALL dswtdir2_globe_dbo.trglobe_dp1_billed_zloaded_1upd();
    /* Custom implementation */
    
    /*
    SELECT x.* INTO #ODBC_Logs FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x
    -- recode
    -- [Winds Feb 18, 2023] - Replaced trGlobe_DP1_Billed_zLoaded_1Upd
    UPDATE xx SET xx.zLoaded = '1'
    from   ttGlobe_DP1_Billed xx
    	inner join #ODBC_Logs yy -- ZFFI_REPORT_ODBC_LATESTLOGS
    			on xx.ZDSP_ORDER = yy.ZDSP_ORDER
    			AND xx.ZDSP_UNIQUEKEY = yy.ZDSP_UNIQUEKEY
    --and ttInnove_PHP.z_Upld_Filename = dbo.ZFFI_REPORT_ODBC_LATESTLOGS.z_Upld_Filename
    Where  Z_MESSAGE Not Like '%is not found%'
    AND Z_MESSAGE Not Like '%requires an assignment to a CO object%'
    AND Z_MESSAGE Not Like '%does not exist in chart of accounts%'
    AND Z_MESSAGE Not Like '%Error in document%'
    AND Z_MESSAGE Not Like '%not defined in chart of accounts%'
    AND Z_MESSAGE Not Like '%not allowed for characteristic%'
    AND Z_MESSAGE Not Like '%Balance in Transaction Currency%'
    AND Data = '01';
    
    
    -- Replace EXEC [dbo].trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd
    ;WITH CTE_WithErrorsBillCycles
    AS
    (
    	SELECT zLegacyCycle_Code,count(Z_MESSAGE) AS ERROR_COUNT
    	from ttGlobe_DP1_Billed
    	inner join #ODBC_Logs xx -- ZFFI_REPORT_ODBC_LATESTLOGS
    					on ttGlobe_DP1_Billed.ZDSP_ORDER = xx.ZDSP_ORDER
    					AND ttGlobe_DP1_Billed.ZDSP_UNIQUEKEY = xx.ZDSP_UNIQUEKEY
    	Where  (Z_MESSAGE  Like '%is not found%'
    			OR Z_MESSAGE  Like '%requires an assignment to a CO object%'
    			OR Z_MESSAGE  Like '%does not exist in chart of accounts%'
    			OR Z_MESSAGE  Like '%Error in document%'
    			OR Z_MESSAGE  Like '%not defined in chart of accounts%'
    			OR Z_MESSAGE  Like '%not allowed for characteristic%'
    			OR Z_MESSAGE  Like '%Balance in Transaction Currency%')
    			AND Data = '01'
    		GROUP BY
    		zLegacyCycle_Code
    			having count(Z_MESSAGE)>0
    	)
    
    	UPDATE xx SET zLegacyCycle_Code = '0'
    	FROM ttGlobe_DP1_Billed xx
    	INNER JOIN CTE_WithErrorsBillCycles yy ON yy.zLegacyCycle_Code = xx.zLegacyCycle_Code;
    */
END;
$procedure$
