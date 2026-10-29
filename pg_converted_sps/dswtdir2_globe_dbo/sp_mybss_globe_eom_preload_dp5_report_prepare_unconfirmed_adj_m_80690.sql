CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_report_prepare_unconfirmed_adj_m()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_adj_manual_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_adj_manual_cache (record, postingdate, column3, ct, st, chargecode, amount, tax, amount_net, brand, spa, rev_type, gl, spb, remark)
    SELECT
        record, postingdate, column3, ct, st, chargecode, amount, tax, amount_net, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.tvglobe_dp5_unconfirmed_adj_tdir2_globe_sap_glunbilled_unconf_g_manualrptsel;
END;
$procedure$
