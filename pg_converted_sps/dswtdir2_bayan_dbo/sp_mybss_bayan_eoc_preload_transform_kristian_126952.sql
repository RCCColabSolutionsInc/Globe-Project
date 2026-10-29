CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_transform_kristian(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    var_billcycle VARCHAR(5);

BEGIN

    /*
    ==================================================================================
    Author:       Winston Madiano
    Create date:  February 9, 2023
    Description:  Transform EOC preload data based on the specified cycle code.
    ==================================================================================

    Converted by: RCC - Kristian Corrales
    Updated date: August 13, 2026
    Time: 12:00 NN
    Description:  Converted from SQL Server Stored Procedure to PostgreSQL
                  Stored Procedure.

    Sample Run:
        CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_transform_kristian('EOC1');

    ==================================================================================
    */

    /*
    ============================================================================
    Get Bill Cycle based on Cycle Code
    ============================================================================
    */

    SELECT billcycle
    INTO var_billcycle
    FROM dswtdir2_bayan_dbo.billcycles
    WHERE LOWER(cyclecode) = LOWER(par_cyclecode);


    /*
    ============================================================================
    1. Clear destination table
    ============================================================================
    */

    DELETE FROM dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
    WHERE LOWER(cycle_code) = LOWER(var_billcycle);


    /*
    ============================================================================
    2. Insert new data
    ============================================================================
    */

    INSERT INTO dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
    (
        cycle_code,
        zrownumber,
        column1,
        column2,
        column3,
        column4,
        column5,
        column6,
        column7,
        column8,
        column9,
        column10,
        column11,
        column12,
        column13,
        column14,
        column15,
        column16,
        column17,
        column18,
        column19
    )
    SELECT
        x.billcycle,
        x.rownumber,
        x.column1,
        x.column2,
        x.column3,
        x.column4,
        x.column5,
        x.column6,
        x.column7,

        CAST(
            CAST(x.column8 AS NUMERIC(18,2))
            AS VARCHAR(50)
        ) AS column8,

        CAST(
            CAST(x.column9 AS NUMERIC(18,2))
            AS VARCHAR(50)
        ) AS column9,

        x.column10,
        x.column11,
        x.column12,
        x.column13,
        x.column14,
        x.column15,
        x.column16,
        x.column17,
        x.column18,
        x.column19

    FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis AS x

    WHERE LOWER(x.billcycle) = LOWER(var_billcycle)

    ORDER BY
        x.billcycle NULLS FIRST,
        x.rownumber NULLS FIRST;


    /*
    ============================================================================
    3. Implement Source Rules
    ============================================================================
    */

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zlegacycycle_codeupd();

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zlegacydsp_orderupd();

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_orderupd();

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

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn18upd();

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn19upd();

    CALL dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_uniquekeyupd();


    /*
    ============================================================================
    4. Delete existing records from Target
    ============================================================================
    */

    DELETE FROM dswtdir2_bayan_dbo.ttbayan_billed
    WHERE LOWER(zsource) = LOWER('TDIR2_Bayan')
      AND LOWER(zlegacycycle_code) = LOWER(var_billcycle);


    /*
    ============================================================================
    5. Insert transformed records into Target
    ============================================================================
    */

    INSERT INTO dswtdir2_bayan_dbo.ttbayan_billed
    (
        zlegacydsp_order,
        zlegacycycle_code,
        column01,
        column02,
        column03,
        column04,
        column05,
        column06,
        column07,
        column08,
        column09,
        column10,
        column11,
        column12,
        column13,
        column14,
        column15,
        column16,
        column17,
        column18,
        column19,
        zdsp_order,
        zdsp_uniquekey,
        zactive,
        zsource,
        zduplicate,
        zloaded,
        zload_message
    )
    SELECT
        zlegacydsp_order,
        zlegacycycle_code,
        zcolumn01,
        zcolumn02,
        zcolumn03,
        zcolumn04,
        zcolumn05,
        zcolumn06,
        zcolumn07,
        zcolumn08,
        zcolumn09,
        zcolumn10,
        zcolumn11,
        zcolumn12,
        zcolumn13,
        zcolumn14,
        zcolumn15,
        zcolumn16,
        zcolumn17,
        zcolumn18,
        zcolumn19,
        zdsp_order,
        zdsp_uniquekey,
        zactive,
        zsource,
        zduplicate,
        zloaded,
        zload_message
    FROM dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled
    WHERE LOWER(zlegacycycle_code) = LOWER(var_billcycle);


    /*
    ============================================================================
    6. Update Target
       Flag records that have already been loaded to SAP.
    ============================================================================
    */

    UPDATE dswtdir2_bayan_dbo.ttbayan_billed AS tt
    SET zloaded = '1'
    FROM dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS odbc
    WHERE LOWER(tt.zdsp_order) = LOWER(odbc.zdsp_order)
      AND LOWER(tt.zdsp_uniquekey) = LOWER(odbc.zdsp_uniquekey)
      AND LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%does not exist for%')
      AND LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%is not allowed for characteristic%')
      AND LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%requires an assignment to a CO object%')
      AND LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%Error in document%')
      AND LOWER(odbc.z_message) NOT SIMILAR TO LOWER('%is not found in table%')
      AND LOWER(tt.column01) = LOWER('01')
      AND LOWER(tt.zlegacycycle_code) = LOWER(var_billcycle);

END;
$procedure$
