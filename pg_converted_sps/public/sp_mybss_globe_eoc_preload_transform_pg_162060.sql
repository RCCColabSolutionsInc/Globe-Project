CREATE OR REPLACE PROCEDURE public.sp_mybss_globe_eoc_preload_transform_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
SELECT BillCycle INTO v_billcycle FROM BillCycles WHERE CycleCode = p_cyclecode;

	-- DSP Migrate equivalent
	-- 1. Clear destination table
	DELETE FROM dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled WHERE Cycle_Code = v_billcycle;


	-- 2. Insert new data
	RAISE NOTICE '%', ('Insert to initial staging table')::text;
	INSERT INTO dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled -- Destination
           (Cycle_Code
           ,zrownumber
           ,Column1
           ,Column2
           ,Column3
           ,Column4
           ,Column5
           ,Column6
           ,Column7
           ,Column8
           ,Column9
           ,Column10)
	SELECT
			x.BillCycle,
			x.RowNumber,
			x.Column1,
			x.Column2,
			x.Column3,
			x.Column4,
			x.Column5,
			x.Column6,
			x.Column7,
			CAST(CAST(x.Column8 as DECIMAL(18,2)) as VARCHAR(50)),
			CAST(CAST(x.Column9 as DECIMAL(18,2)) as VARCHAR(50)),
			x.Column10
	FROM sdbtdir2_globe.sapglbilled_ssis x -- From SQL SSIS table
	WHERE x.BillCycle = v_billcycle
	ORDER BY x.BillCycle,x.RowNumber;

	-- Disabled JUne 26 2023
	/*
	-- Adjusts batch numbers for BC06 and BC08 due to an unusual order in processing. 
	-- For BC06, it decreases the batch number by 1.
	-- For BC08, it increases the batch number by 1.
	-- Applies only to records in 'stInnove_Billed_TDIR2_Innove_sapglbilled' where Column1 is '00'.
	*/
	/*
	IF @BillCycle = 'BC06'
	BEGIN
		UPDATE x SET Column5 = CAST((TRY_PARSE(Column5 as INT) - 1) as NVARCHAR(20))
		FROM [stGlobe_DP1_Billed_TDIR2_Globe_saplbilled] x
		WHERE x.Column1 = '00' AND x.Cycle_Code = @BillCycle;
	END
	ELSE IF @BillCycle = 'BC08'
	BEGIN
		UPDATE x SET Column5 = CAST((TRY_PARSE(Column5 as INT) + 1) as NVARCHAR(20))
		FROM [stGlobe_DP1_Billed_TDIR2_Globe_saplbilled] x
		WHERE x.Column1 = '00' AND x.Cycle_Code = @BillCycle;
	END
	*/

	-- 3 Implement Source Rule
	RAISE NOTICE '%', ('Data transformations')::text;
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zLegacyCycle_CodeUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zLegacyDSP_OrderUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zDSP_OrderUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zDataUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zPosting_DateUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zSAPFIGLUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zCTUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zSTUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zCH_CodeUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zDP_CodeUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zAmountUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zHitsUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zUOMUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zBRANDUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zSPAUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zSPA_Rule2Upd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zRev_TypeUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zGL_CodeUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zSPBUpd();
	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zRemarksUpd();
	-- EXEC [dswTDIR2_Globe].[dbo].srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_BatchNoUpd 

	-- By winds June 26 2023. Sync batch number
	UPDATE x
	SET x.zST=Cast(Cast(y.BATCH_NO AS int) || 1 AS VARCHAR)
	FROM stGlobe_DP1_Billed_TDIR2_Globe_saplbilled x
			 INNER JOIN dbo.ZTF0001S y
					 ON x.Column2 =y.FROM_SYSTEM  
						AND x.Column3 =y.TO_SYSTEM  
						AND x.Column4 =y.EVENT  
	WHERE Column1 = '00'
	AND y.BUKRS ='GLOB'
	AND zLegacyCycle_Code =v_billcycle;

	CALL dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zDSP_UniqueKeyUpd();


	DELETE FROM dbo.ttGlobe_DP1_Billed WHERE zSource = 'TDIR2_Globe' AND zLegacyCycle_Code = v_billcycle;
	-- EXEC [dbo].srGlobe_DP1_Billed_TDIR2_Globe_saplbilledDel -- [Winds Feb 9, 2023] - removed. Replaced with the code above.
	
	
	INSERT INTO dbo.ttGlobe_DP1_Billed (  zLegacyDSP_Order, zLegacyCycle_Code, Data, Posting_Date, SAPFIGL, CT, ST, CH_Code, DP_Code, Amount, Hits, UOM, WO_IND, CC, NB_IND, Brand, SPA, Rev_type, GL_Code, SPB, Remarks, zDSP_Order, zDSP_UniqueKey, zActive, zSource, zDuplicate, zLoaded, zLoad_Message)
	SELECT   zLegacyDSP_Order,zLegacyCycle_Code,zData,zPosting_Date,zSAPFIGL,zCT,zST,zCH_Code,zDP_Code,zAmount,zHits,zUOM,zWO_IND,zCC,zNB_IND,zBrand,zSPA,zRev_type,zGL_Code,zSPB,zRemarks,zDSP_Order,zDSP_UniqueKey,zActive,zSource,zDuplicate,zLoaded,zLoad_Message 
	FROM dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled WHERE zLegacyCycle_Code = v_billcycle;
	-- EXEC [dbo].srGlobe_DP1_Billed_TDIR2_Globe_saplbilledIns -- [Winds Feb 9, 2023] - removed. Replaced with the code above.

	-- Implemet Target Rule
	-- [Winds Feb 11, 2023] - added back. Flag the ones that are already loaded to sap as "Loaded" so they will not be included to the export again.
	-- [Winds Feb 9, 2023] - should only  be executed during postload
	-- EXEC [dbo].trGlobe_DP1_Billed_zLoaded_1Upd


	-- Custom implementation
	-- [Winds Feb 18, 2023] - Replaced trGlobe_DP1_Billed_zLoaded_1Upd

	-- Temporarily comment to bypass if need to force previously processed iems
	-- ### START COMMENT HERE
	-- *** MANUAL FIX: T-SQL's "UPDATE alias SET alias.col FROM tbl alias JOIN ..."
	-- extension syntax isn't valid PostgreSQL (the UPDATE target must be the
	-- real table, not a FROM-clause alias) - rewritten below to target
	-- ttGlobe_DP1_Billed directly and move the join into FROM/WHERE. ***
	-- *** MANUAL REVIEW NEEDED: linked server to SAP HANA - needs postgres_fdw / hana connectivity, not a same-instance schema ***
	UPDATE ttGlobe_DP1_Billed AS xx SET zLoaded = '1'
	FROM dgs4hana_tdir1.vw_ZFFI_REPORT_ODBC_LATESTLOGS yy -- ZFFI_REPORT_ODBC_LATESTLOGS
	--and ttInnove_PHP.z_Upld_Filename = dbo.ZFFI_REPORT_ODBC_LATESTLOGS.z_Upld_Filename
	Where  xx.ZDSP_ORDER = yy.ZDSP_ORDER
	AND xx.ZDSP_UNIQUEKEY = yy.ZDSP_UNIQUEKEY
	AND Z_MESSAGE Not Like '%is not found%'
	AND Z_MESSAGE Not Like '%requires an assignment to a CO object%'
	AND Z_MESSAGE Not Like '%does not exist in chart of accounts%'
	AND Z_MESSAGE Not Like '%Error in document%'
	AND Z_MESSAGE Not Like '%not defined in chart of accounts%'
	AND Z_MESSAGE Not Like '%not allowed for characteristic%'
	AND Z_MESSAGE Not Like '%Balance in Transaction Currency%'
	AND Z_MESSAGE Not Like '%Header Control on Amount is Invalid%' -- added by winds Dec 18, 2023
	AND Data = '01'
	AND zLegacyCycle_Code = v_billcycle;
	
	

	
	
	WITH CTE_WithErrorsBillCycles
	AS
	(
		SELECT zLegacyCycle_Code,count(Z_MESSAGE) AS ERROR_COUNT
		from ttGlobe_DP1_Billed
		-- *** MANUAL REVIEW NEEDED: linked server to SAP HANA - needs postgres_fdw / hana connectivity, not a same-instance schema ***
		inner join dgs4hana_tdir1.vw_ZFFI_REPORT_ODBC_LATESTLOGS xx -- ZFFI_REPORT_ODBC_LATESTLOGS
						on ttGlobe_DP1_Billed.ZDSP_ORDER = xx.ZDSP_ORDER
						AND ttGlobe_DP1_Billed.ZDSP_UNIQUEKEY = xx.ZDSP_UNIQUEKEY
		Where  (Z_MESSAGE  Like '%is not found%'
				OR Z_MESSAGE  Like '%requires an assignment to a CO object%'
				OR Z_MESSAGE  Like '%does not exist in chart of accounts%'
				OR Z_MESSAGE  Like '%Error in document%'
				OR Z_MESSAGE  Like '%not defined in chart of accounts%'
				OR Z_MESSAGE  Like '%not allowed for characteristic%'
				OR Z_MESSAGE  Like '%Balance in Transaction Currency%'
				OR Z_MESSAGE  Like '%Balance in Transaction Currency%'
				OR Z_MESSAGE  Like '%Header Control on Amount is Invalid%' -- added by winds Dec 18, 2023
				)
				AND Data = '01'
				AND zLegacyCycle_Code = v_billcycle
			GROUP BY
			zLegacyCycle_Code
				having count(Z_MESSAGE)>0
		)

		-- *** MANUAL FIX: same UPDATE...FROM...JOIN restructuring as above
		-- (T-SQL's "UPDATE alias SET alias.col FROM tbl alias JOIN ..." extension
		-- syntax isn't valid PostgreSQL). ***
		UPDATE ttGlobe_DP1_Billed AS xx SET zLoaded = '0'
		FROM CTE_WithErrorsBillCycles yy
		WHERE yy.zLegacyCycle_Code = xx.zLegacyCycle_Code;

	-- END COMMENT HERE
END;
$procedure$
