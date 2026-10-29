CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 2, 2023 */
/* Modified:	Arnel Martinez */
/* Updated  date: October 6, 2026 */
/* Create date: Feb 2, 2023 */

/* Description: Report */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_BillCycle VARCHAR(5);
BEGIN
    SELECT
        billcycle
        INTO var_BillCycle
        FROM dswtdir2_innove_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
		CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_chargecodemissing();
		CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_subscriber_typemissing();
		CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_preload(var_BillCycle);
--		CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_reconsummaryphp();
--		CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_reconsummaryusd();
END;
$procedure$
