CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_report_prepare_unconfirmed_advan()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_advanced_msf_charges_manual_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_advanced_msf_charges_manual_cache ("Customer Type", "Service Type", "Revenue Type", "Charge Code", "Offer ID", "Offer Description", "Charge Type", amount, brand, spa, rev_type, gl, spb, remark)
    SELECT
        "Customer Type", "Service Type", "Revenue Type", "Charge Code", "Offer ID", "Offer Description", "Charge Type", amount, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.tvglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_advanced_msf_charges_manualrptsel;
END;
$procedure$
