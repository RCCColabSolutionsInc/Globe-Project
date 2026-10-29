CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_transform_pg()
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 9, 2023 */
/* Description: Transform postload data */
/* ============================================= */
BEGIN
    /* Original version */
    CALL dswtdir2_bayan_dbo.trbayan_billed_zloaded_upd()
    /* Loaded Records */
    ;
    /* Custom vestion */
    
    /*
    SELECT x.* INTO #ODBC_Logs FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x
    UPDATE tt SET tt.zLoaded = '1'
    FROM   dbo.ttBayan_Billed AS tt
    		INNER JOIN #ODBC_Logs as ODBC -- dbo.ZFFI_REPORT_ODBC_LatestLogs AS ODBC
    				ON tt.zDSP_Order = ODBC.ZDSP_ORDER
    				AND tt.zDSP_UniqueKey = ODBC.ZDSP_UNIQUEKEY
    WHERE  ( ODBC.Z_MESSAGE NOT LIKE '%does not exist for%' )
    		AND ( ODBC.Z_MESSAGE NOT LIKE '%is not allowed for characteristic%' )
    		AND ( ODBC.Z_MESSAGE NOT LIKE '%requires an assignment to a CO object%' )
    		AND ( ODBC.Z_MESSAGE NOT LIKE '%Error in document%' )
    		AND ( ODBC.Z_MESSAGE NOT LIKE '%is not found in table%' )
    		AND ( tt.Column01 = '01' )
    */
END;
$procedure$
