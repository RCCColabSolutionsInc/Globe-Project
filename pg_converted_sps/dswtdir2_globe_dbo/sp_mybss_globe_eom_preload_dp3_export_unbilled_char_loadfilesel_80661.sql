CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_export_unbilled_char_loadfilesel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        etl_db_dbo.fn_cleantxt(column01), etl_db_dbo.fn_cleantxt(column02), etl_db_dbo.fn_cleantxt(column03), etl_db_dbo.fn_cleantxt(column04), etl_db_dbo.fn_cleantxt(column05), etl_db_dbo.fn_cleantxt(column06), etl_db_dbo.fn_cleantxt(column07), etl_db_dbo.fn_cleantxt(column08), etl_db_dbo.fn_cleantxt(column09), etl_db_dbo.fn_cleantxt(column10), etl_db_dbo.fn_cleantxt(column11), etl_db_dbo.fn_cleantxt(column12), etl_db_dbo.fn_cleantxt(zdsp_order), etl_db_dbo.fn_cleantxt(zdsp_uniquekey)
        FROM dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel
        ORDER BY 1 NULLS FIRST, CAST (zdsp_order AS INTEGER) NULLS FIRST;
END;
$procedure$
