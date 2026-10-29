CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp3_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 8, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* Original version */
    CALL dswtdir2_globe_dbo.trglobe_dp3_unbilled_char_zloaded_1upd();
    /* Loaded Records */
    CALL dswtdir2_globe_dbo.trglobe_dp3_unbilled_char_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
    /* Custom version */
    
    /*
    SELECT * INTO #LATEST_ODBC FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x;
    
    UPDATE x SET zloaded = '1'
    from   ttGlobe_DP3_Unbilled_Char x
    	INNER JOIN #LATEST_ODBC odbc ON x.ZDSP_ORDER = odbc.ZDSP_ORDER AND x.ZDSP_UNIQUEKEY = odbc.ZDSP_UNIQUEKEY
    Where  Z_MESSAGE Not Like '%is not found%'
    AND Z_MESSAGE Not Like '%requires an assignment to a CO object%'
    	AND Z_MESSAGE Not Like '%does not exist in chart of accounts%'
    	AND Z_MESSAGE Not Like '%Error in document%'
    	AND Z_MESSAGE Not Like '%not defined in chart of accounts%'
    	AND Z_MESSAGE Not Like '%not allowed for characteristic%'
    	AND Z_MESSAGE Not Like '%Balance in Transaction Currency%'
    	AND Column01 = '01';
    
    
    SELECT
    zSource,count(Z_MESSAGE) AS ERROR_COUNT
    INTO #ERROR
    from   ttGlobe_DP3_Unbilled_Char
    		inner join #LATEST_ODBC odbc
    				on ttGlobe_DP3_Unbilled_Char.ZDSP_ORDER = odbc.ZDSP_ORDER
    				AND ttGlobe_DP3_Unbilled_Char.ZDSP_UNIQUEKEY = odbc.ZDSP_UNIQUEKEY
    Where  (Z_MESSAGE  Like '%is not found%'
    		OR Z_MESSAGE  Like '%requires an assignment to a CO object%'
    		OR Z_MESSAGE  Like '%does not exist in chart of accounts%'
    		OR Z_MESSAGE  Like '%Error in document%'
    		OR Z_MESSAGE  Like '%not defined in chart of accounts%'
    		OR Z_MESSAGE  Like '%not allowed for characteristic%'
    		OR Z_MESSAGE  Like '%Balance in Transaction Currency%')
    		AND column01= '01'
    GROUP BY zSource
    having count(Z_MESSAGE)>0
    
    UPDATE ttGlobe_DP3_Unbilled_Char SET zLoaded = '0'
    WHERE zSource
    IN
    (
    	SELECT e.zSource FROM #ERROR e
    
    );
    */
END;
$procedure$
