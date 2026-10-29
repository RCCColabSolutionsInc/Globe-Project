CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unbilled_char_varianceintotalamount_cache (
        sap_total, 
        summary_report_total, 
        variance
    )
    SELECT
        dswtdir2_bayan_dbo.safe_cast_numeric(sap_total::text), 
        dswtdir2_bayan_dbo.safe_cast_numeric(summary_report_total::text), 
        dswtdir2_bayan_dbo.safe_cast_numeric(variance::text)
    FROM dswtdir2_bayan_dbo.tvbayan_unbilled_char_varianceintotalamountrptsel;

    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_rpt_prep_no_subtype();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_rpt_prep_no_chrgcode();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_rpt_prep_preload();
    --CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_rpt_prep_amt_varianc();
END;
$procedure$
