CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: Report */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_BillCycle VARCHAR(5);
BEGIN
    SELECT
        billcycle
        INTO var_BillCycle
        FROM dswtdir2_globe_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_control_recon(var_BillCycle);
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_manual_report(var_BillCycle);
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_preload(var_BillCycle);
END;
$procedure$
