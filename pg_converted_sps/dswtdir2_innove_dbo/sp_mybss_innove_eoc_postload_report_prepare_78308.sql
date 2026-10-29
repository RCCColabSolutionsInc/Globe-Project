CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_prepare(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
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
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_prepare_dp1_billed_error(var_BillCycle);
    CALL dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_prepare_dp1_billed_valid(var_BillCycle);
END;
$procedure$
