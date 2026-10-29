CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_transform_converted(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: February 2, 2023 */
/* Description: Data transformation */
/* [winds Feb 9, 2023] - Add Cycle code parameter. It should only process based on parameter instead of processing everything. */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_BillCycle VARCHAR(5);
BEGIN
    SELECT
        billcycle
        INTO var_BillCycle
        FROM dswtdir2_bayan_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
        WHERE LOWER(cycle_code) = LOWER(var_BillCycle);
    /* 2. Insert new data */
    INSERT INTO dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
    /* Destination */
    (cycle_code, zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19)
    SELECT
        x.billcycle, x.rownumber, x.column1, x.column2, x.column3, x.column4, x.column5, x.column6, x.column7, CAST (CAST (x.column8 AS NUMERIC(18, 2)) AS VARCHAR(50)), CAST (CAST (x.column9 AS NUMERIC(18, 2)) AS VARCHAR(50)), x.column10, x.column11, x.column12, x.column13, x.column14, x.column15, x.column16, x.column17, x.column18, x.column19
        FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis AS x
        /* From SQL SSIS table */
        WHERE LOWER(x.billcycle) = LOWER(var_BillCycle)
        ORDER BY x.billcycle NULLS FIRST, x.rownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zlegacycycle_codeupd();
    /* Cycle Code */
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zlegacydsp_orderupd();
    /* Unique Key */
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_orderupd();
    /* Header identifier in SAP File */
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn01upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn02upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn03upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn04upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn05upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn06upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn07upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn08upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn09upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn10upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn11upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn12upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn13upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn14upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn15upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn16upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn17upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_upd();
    /* Update Target from Source */
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn18upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn19upd();
    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_uniquekeyupd();
    DELETE FROM dswtdir2_bayan_dbo.ttbayan_billed
        WHERE LOWER(zsource) = LOWER('TDIR2_Bayan') AND LOWER(zlegacycycle_code) = LOWER(var_BillCycle);
    /* [Winds Feb 9, 2023] -- delete per bc code to allow simoultaneous processing */
    /* EXEC [dbo].srBayan_Billed_TDIR2_Bayan_sapglbilledDel	-- Target Delete by Source -- [Winds Feb 9, 2023] - change implementation */
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_billed (zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, zlegacycycle_code, zcolumn01, zcolumn02, zcolumn03, zcolumn04, zcolumn05, zcolumn06, zcolumn07, zcolumn08, zcolumn09, zcolumn10, zcolumn11, zcolumn12, zcolumn13, zcolumn14, zcolumn15, zcolumn16, zcolumn17, zcolumn18, zcolumn19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
        WHERE LOWER(zlegacycycle_code) = LOWER(var_BillCycle);
    /* EXEC [dbo].srBayan_Billed_TDIR2_Bayan_sapglbilledIns	-- Source to Target Insert -- -- [Winds Feb 9, 2023] - change implementation */
    /* Implemet Target Rule */
    /* [Winds Feb 11, 2023] - added back. Flag the ones that are already loaded to sap as "Loaded" so they will not be included to the export again. */
    /* [Winds Feb 9, 2023] - Commented out. Not needed in preload */
    /* Original version */
    /* temporarily commented out April 19 */
    /* EXEC [dbo].trBayan_Billed_zloaded_Upd	-- Loaded Records */
    /* [Winds Feb 14 2023] - equivalent to trBayan_Billed_zloaded_Upd */
    /* Custom version */
    UPDATE dswtdir2_bayan_dbo.ttbayan_billed AS tt
    SET zloaded = '1'
    FROM dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS odbc
    /* dbo.ZFFI_REPORT_ODBC_LatestLogs AS ODBC */
        WHERE LOWER(tt.zdsp_order) = LOWER(odbc.zdsp_order) AND LOWER(tt.zdsp_uniquekey) = LOWER(odbc.zdsp_uniquekey) AND (LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%does not exist for%')) AND (LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%is not allowed for characteristic%')) AND (LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%requires an assignment to a CO object%')) AND (LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%Error in document%')) AND (LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%is not found in table%')) AND (LOWER(tt.column01) = LOWER('01')) AND LOWER(tt.zlegacycycle_code) = LOWER(var_BillCycle);
END;
$procedure$
