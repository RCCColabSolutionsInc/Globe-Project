CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 2, 2023 */
/* Description: Transform postload data */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON; */
    /* DSP Migrate equivalent */
    /* 3 Implement Source Rule */
    
    /*
    EXEC [dbo].[srInnove_Billed_TDIR2_Innove_sapglbilled_zLegacyCycle_CodeUpd] --	Cycle Code
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zLegacyDSP_OrderUpd	-- Unique Key
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zDSP_OrderUpd	-- Header identifier in SAP File
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn01Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn02Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn03Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn04Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn05Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn06Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn07Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn08Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn09Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn10Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn11Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn12Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn13Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn14Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn15Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn16Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn17Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn18Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zColumn19Upd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilled_zDSP_UniqueKeyUpd
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilledDel	-- Target Delete by Source
    EXEC [dbo].srInnove_Billed_TDIR2_Innove_sapglbilledIns	-- Source to Target Insert
    */
    /* Implemet Target Rule */
    CALL dswtdir2_innove_dbo.trinnove_billed_zloaded_upd();
    /* Loaded Records */
    CALL dswtdir2_innove_dbo.trinnove_billed_zloaded_0_cyclecodeupd()
    /* Update all records as not loaded if any error */
    ;
    /* Commented out April, 18, 2023. Stick to the original implementation */
    /* [Winds Feb 14, 2023] */
    
    /*
    UPDATE tt SET zLoaded = '1'
    FROM   dbo.ttInnove_Billed AS tt
    INNER JOIN [dgS4HANA_TDIR1].[dbo].vw_RT_ZFFI_REPORT_ODBC AS ODBC -- dbo.ZFFI_REPORT_ODBC_LatestLogs AS ODBC
    		ON tt.zDSP_Order = ODBC.ZDSP_ORDER
    		AND tt.zDSP_UniqueKey = ODBC.ZDSP_UNIQUEKEY
    WHERE  ( ODBC.Z_MESSAGE NOT LIKE '%does not exist for%' )
    AND ( ODBC.Z_MESSAGE NOT LIKE '%is not allowed for characteristic%' )
    AND ( ODBC.Z_MESSAGE NOT LIKE '%requires an assignment to a CO object%' )
    AND ( ODBC.Z_MESSAGE NOT LIKE '%Error in document%' )
    AND ( ODBC.Z_MESSAGE NOT LIKE '%is not found in table%' )
    AND ( tt.Column01 = '01' );
    
    ;WITH CTE_BillCycleWithError
    AS
    (
    	SELECT zLegacyCycle_Code,count(Z_MESSAGE) AS ERROR_COUNT from   ttInnove_Billed
    	inner join [dgS4HANA_TDIR1].[dbo].vw_RT_ZFFI_REPORT_ODBC as ODBC -- ZFFI_REPORT_ODBC_LATESTLOGS  AS ODBC
    			on ttInnove_Billed.ZDSP_ORDER = ODBC.ZDSP_ORDER
    			AND ttInnove_Billed.ZDSP_UNIQUEKEY = ODBC.ZDSP_UNIQUEKEY
    	Where   (( ODBC.Z_MESSAGE  LIKE '%does not exist for%' )
    	OR ( ODBC.Z_MESSAGE  LIKE '%is not allowed for characteristic%' )
    	OR ( ODBC.Z_MESSAGE  LIKE '%requires an assignment to a CO object%' )
    	OR ( ODBC.Z_MESSAGE  LIKE '%Error in document%' )
    	OR ( ODBC.Z_MESSAGE  LIKE '%is not found in table%' ))
    	AND Column01 = '01'
    	GROUP BY zLegacyCycle_Code
    	having count(Z_MESSAGE)>0
    )
    UPDATE tt
    	SET zLegacyCycle_Code = '0'
    FROM ttInnove_Billed tt
    INNER JOIN CTE_BillCycleWithError xx
    ON xx.zLegacyCycle_Code = tt.zLegacyCycle_Code;
    */
END;
$procedure$
