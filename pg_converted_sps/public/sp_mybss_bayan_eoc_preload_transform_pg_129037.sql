CREATE OR REPLACE PROCEDURE public.sp_mybss_bayan_eoc_preload_transform_pg(IN p_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    /*
      SQL Server:
        DECLARE @CycleCode NVARCHAR(5);
        SELECT @CycleCode = @CycleCode
        FROM BillCycles
        WHERE BillCycle = @BillCycle;

      The original assignment assigns the variable to itself and has no
      effect on the procedure, so it is intentionally omitted.
    */

    -- 1. Clear destination table for the requested billing cycle.
    DELETE FROM public.stbayan_billed_tdir2_bayan_sapglbilled
    WHERE cycle_code = p_billcycle;

    -- 2. Insert transformed source data.
    INSERT INTO public.stbayan_billed_tdir2_bayan_sapglbilled
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
        CAST(CAST(x.column8 AS numeric(18,2)) AS varchar(50)),
        CAST(CAST(x.column9 AS numeric(18,2)) AS varchar(50)),
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
    FROM sdbtdir2_bayan.sap_glbilled_ssis AS x
    WHERE x.billcycle = p_billcycle
    ORDER BY x.billcycle, x.rownumber;

    -- 3. Implement source rules.
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zlegacycycle_codeupd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zlegacydsp_orderupd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_orderupd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn01upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn02upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn03upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn04upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn05upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn06upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn07upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn08upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn09upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn10upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn11upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn12upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn13upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn14upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn15upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn16upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn17upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn18upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zcolumn19upd();
    CALL public.srbayan_billed_tdir2_bayan_sapglbilled_zdsp_uniquekeyupd();

    -- Remove existing target rows for this source and billing cycle.
    DELETE FROM public.ttbayan_billed
    WHERE zsource = 'TDIR2_Bayan'
      AND zlegacycycle_code = p_billcycle;

    -- 4. Insert processed staging rows into target table.
    INSERT INTO public.ttbayan_billed
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
    FROM public.stbayan_billed_tdir2_bayan_sapglbilled
    WHERE zlegacycycle_code = p_billcycle;

    -- 5. Mark records that already have a successful SAP processing log.
    UPDATE public.ttbayan_billed AS tt
    SET zloaded = '1'
    FROM dgs4hana_tdir1.vw_zffi_report_odbc_latestlogs AS odbc
    WHERE tt.zdsp_order = odbc.zdsp_order
      AND tt.zdsp_uniquekey = odbc.zdsp_uniquekey
      AND odbc.z_message NOT LIKE '%does not exist for%'
      AND odbc.z_message NOT LIKE '%is not allowed for characteristic%'
      AND odbc.z_message NOT LIKE '%requires an assignment to a CO object%'
      AND odbc.z_message NOT LIKE '%Error in document%'
      AND odbc.z_message NOT LIKE '%is not found in table%'
      AND tt.column01 = '01'
      AND tt.zlegacycycle_code = p_billcycle;

END;
$procedure$
