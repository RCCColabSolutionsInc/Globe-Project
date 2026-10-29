CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_man()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    Dependencies
    - [ttGlobe_DP3_Unbilled_Char]
    - [ZTF0002S]
    - [ZFCO_UDT_MAP]
    */
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache (ct, st, charge_code, sum_of_amount, "Unbilled charges", diff, tax_rate, net_of_tax, spa, rev_type, gl, spb, remark)
    SELECT
        ct, st, charge_code, sum_of_amount, "Unbilled charges", diff, tax_rate, net_of_tax, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.tvglobe_dp3_unbilled_char_manual_agg_rptsel;
END;
$procedure$
