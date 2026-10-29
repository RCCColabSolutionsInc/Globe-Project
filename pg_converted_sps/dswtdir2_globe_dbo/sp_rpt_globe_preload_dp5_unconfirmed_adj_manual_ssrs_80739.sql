CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp5_unconfirmed_adj_manual_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        record, postingdate, column3, ct, st, chargecode, amount, tax, amount_net, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_adj_manual_cache;
END;
$procedure$
