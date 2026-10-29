CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp5_unconfirmed_advanced_msf_charges_manua(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "Customer Type", "Service Type", "Revenue Type", "Charge Code", "Offer ID", "Offer Description", "Charge Type", amount, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp5_unconfirmed_advanced_msf_charges_manual_cache;
END;
$procedure$
