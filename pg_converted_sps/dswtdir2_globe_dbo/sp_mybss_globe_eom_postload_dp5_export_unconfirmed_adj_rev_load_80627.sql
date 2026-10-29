CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_export_unconfirmed_adj_rev_load(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        'DocNum', 'Co. Code', 'Fiscal.Yr', 'zDSP_order', 'ASzDSP_UniqueKey'
    UNION ALL
    SELECT
        docnum, "Co. Code", "Fiscal.Yr", CAST (zdsp_order AS VARCHAR(255)), aszdsp_uniquekey
        FROM dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_rev_exportsel;
END;
$procedure$
