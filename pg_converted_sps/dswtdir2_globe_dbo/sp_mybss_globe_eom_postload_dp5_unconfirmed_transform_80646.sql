CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_unconfirmed_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 14, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* original */
    CALL dswtdir2_globe_dbo.trglobe_dp4_unbilled_adj_zloaded_0_error_lineupd();
    /* Custom version */
    
    /*
    SELECT * INTO #LATEST_ODBC FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x;
    
    
    SELECT
    zSource,count(Z_MESSAGE) AS ERROR_COUNT
    INTO #ERROR
    from   ttGlobe_DP5_Unconfirmed
    		 inner join #LATEST_ODBC odbc
    				 on ttGlobe_DP5_Unconfirmed.ZDSP_ORDER = odbc.ZDSP_ORDER
    					AND ttGlobe_DP5_Unconfirmed.ZDSP_UNIQUEKEY = odbc.ZDSP_UNIQUEKEY
     Where  (Z_MESSAGE  Like '%is not found%'
    		 OR Z_MESSAGE  Like '%requires an assignment to a CO object%'
    		 OR Z_MESSAGE  Like '%does not exist in chart of accounts%'
    		 OR Z_MESSAGE  Like '%Error in document%'
    		 OR Z_MESSAGE  Like '%not defined in chart of accounts%'
    		 OR Z_MESSAGE  Like '%not allowed for characteristic%'
    		 OR Z_MESSAGE  Like '%Balance in Transaction Currency%')
    		 --AND column01= '01'
      GROUP BY --ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER,ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY
      zSource
       having count(Z_MESSAGE)>0;
    
    UPDATE ttGlobe_DP5_Unconfirmed SET zLoaded = '0'
    WHERE zSource
    IN
    (
    	SELECT e.zSource FROM #ERROR e
    
    );
    */
END;
$procedure$
