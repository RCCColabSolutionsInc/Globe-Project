CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_transform_pg()
 LANGUAGE plpgsql
AS $procedure$
	BEGIN
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zlegacycycle_codeupd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zLegacydsp_orderupd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zdsp_orderupd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zLegacydsp_orderupd();

		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn01Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn02Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn03Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn04Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn05Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn06Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn07Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn08Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn09Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn10Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn11Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn12Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn13Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn14Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn15Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn16Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn17Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn18Upd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zcolumn19Upd();

		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_zdsp_uniquekeyupd();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilleddel();
		CALL dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilledins();

		/* Implemet Target Rule */
		-- CALL dswtdir2_innove_dbo.trinnove_billed_zloaded_upd();
		/* Loaded Records */
		-- CALL dswtdir2_innove_dbo.trinnove_billed_zloaded_0_cyclecodeupd();
		/* Update all records as not loaded if any error */

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
