CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_export_unbilled_adj_rev_loadfile(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        'DocNum', 'Co. Code', 'Fiscal.Yr', 'zDSP_order', 'ASzDSP_UniqueKey'
    UNION ALL
    SELECT
        etl_db_dbo.fn_cleantxt(docnum), etl_db_dbo.fn_cleantxt("Co. Code"::NUMERIC(18, 0)), etl_db_dbo.fn_cleantxt("Fiscal.Yr"), etl_db_dbo.fn_cleantxt(CAST (zdsp_order AS VARCHAR(200))), etl_db_dbo.fn_cleantxt(aszdsp_uniquekey)
        FROM dswtdir2_globe_dbo.txglobe_dp4_unbilled_adj_rev_exportsel;
END;
$procedure$
