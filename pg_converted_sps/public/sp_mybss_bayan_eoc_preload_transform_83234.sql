CREATE OR REPLACE PROCEDURE public.sp_mybss_bayan_eoc_preload_transform(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_BillCycle VARCHAR(5);
BEGIN

    -- Fetch BillCycle parameter
    SELECT "BillCycle" 
    INTO v_BillCycle 
    FROM dbo."BillCycles" 
    WHERE "CycleCode" = 'BC01';

    -- 1. Clear destination table
    DELETE FROM stBayan_Billed_TDIR2_Bayan_sapglbilled 
    WHERE "Cycle_Code" = 'BC01';

    -- 2. Insert new data
    INSERT INTO stBayan_Billed_TDIR2_Bayan_sapglbilled (
        "Cycle_Code",
        "zrownumber",
        "Column1",
        "Column2",
        "Column3",
        "Column4",
        "Column5",
        "Column6",
        "Column7",
        "Column8",
        "Column9",
        "Column10",
        "Column11",
        "Column12",
        "Column13",
        "Column14",
        "Column15",
        "Column16",
        "Column17",
        "Column18",
        "Column19"
    )
    SELECT
        x."BillCycle",
        x."RowNumber",
        x."Column1",
        x."Column2",
        x."Column3",
        x."Column4",
        x."Column5",
        x."Column6",
        x."Column7",
        CAST(CAST(x."Column8" AS NUMERIC(18,2)) AS VARCHAR(50)),
        CAST(CAST(x."Column9" AS NUMERIC(18,2)) AS VARCHAR(50)),
        x."Column10",
        x."Column11",
        x."Column12",
        x."Column13",
        x."Column14",
        x."Column15",
        x."Column16",
        x."Column17",
        x."Column18",
        x."Column19"
    FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis x
    WHERE x."BillCycle" = 'BC01'
    ORDER BY x."BillCycle", x."RowNumber";


    -- 3. Implement Source Rules (Call nested procedures)
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zLegacyCycle_CodeUpd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zLegacyDSP_OrderUpd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zDSP_OrderUpd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn01Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn02Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn03Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn04Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn05Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn06Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn07Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn08Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn09Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn10Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn11Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn12Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn13Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn14Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn15Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn16Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn17Upd();
    --CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_Column05_batchno_Upd();
	--CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_upd();

	UPDATE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;

    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn18Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn19Upd();
    CALL srBayan_Billed_TDIR2_Bayan_sapglbilled_zDSP_UniqueKeyUpd();


    -- Delete existing records in target staging
    DELETE FROM ttBayan_Billed 
    WHERE "zSource" = 'TDIR2_Bayan' 
      AND "zLegacyCycle_Code" = 'BC01';


    -- Insert transformation results into target table
    INSERT INTO ttBayan_Billed (
        "zLegacyDSP_Order", 
        "zLegacyCycle_Code", 
        "Column01", 
        "Column02", 
        "Column03", 
        "Column04", 
        "Column05", 
        "Column06", 
        "Column07", 
        "Column08", 
        "Column09", 
        "Column10", 
        "Column11", 
        "Column12", 
        "Column13", 
        "Column14", 
        "Column15", 
        "Column16", 
        "Column17", 
        "Column18", 
        "Column19", 
        "zDSP_Order", 
        "zDSP_UniqueKey", 
        "zActive", 
        "zSource", 
        "zDuplicate", 
        "zLoaded", 
        "zLoad_Message"
    )
    SELECT  
        "zLegacyDSP_Order", 
        "zLegacyCycle_Code", 
        "zColumn01", 
        "zColumn02", 
        "zColumn03", 
        "zColumn04", 
        "zColumn05", 
        "zColumn06", 
        "zColumn07", 
        "zColumn08", 
        "zColumn09", 
        "zColumn10", 
        "zColumn11", 
        "zColumn12", 
        "zColumn13", 
        "zColumn14", 
        "zColumn15", 
        "zColumn16", 
        "zColumn17", 
        "zColumn18", 
        "zColumn19", 
        "zDSP_Order", 
        "zDSP_UniqueKey", 
        "zActive", 
        "zSource", 
        "zDuplicate", 
        "zLoaded", 
        "zLoad_Message"
    FROM stBayan_Billed_TDIR2_Bayan_sapglbilled 
    WHERE "zLegacyCycle_Code" = 'BC01';


    -- UPDATE using explicit Postgres UPDATE ... FROM syntax
    UPDATE ttBayan_Billed AS tt
    SET "zLoaded" = '1'
    FROM dgs4hana_tdir1_dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS AS ODBC
    WHERE tt."zDSP_Order" = ODBC."ZDSP_ORDER"
      AND tt."zDSP_UniqueKey" = ODBC."ZDSP_UNIQUEKEY"
      AND ODBC."Z_MESSAGE" NOT LIKE '%does not exist for%'
      AND ODBC."Z_MESSAGE" NOT LIKE '%is not allowed for characteristic%'
      AND ODBC."Z_MESSAGE" NOT LIKE '%requires an assignment to a CO object%'
      AND ODBC."Z_MESSAGE" NOT LIKE '%Error in document%'
      AND ODBC."Z_MESSAGE" NOT LIKE '%is not found in table%'
      AND tt."Column01" = '01'
      AND tt."zLegacyCycle_Code" = 'BC01';

END;
$procedure$
