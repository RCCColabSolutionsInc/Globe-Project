CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 2, 2023 */
/* Description: Report */
/* ============================================= */
/* ex: EOC1 to EOC11 */
/* ============================================= */
/* Modified By:	Arnel Martinez */
/* Create date: October 15, 2026 */
/* Description: Report */
/* ============================================= */
/* ex: BC01 */
DECLARE
    v_billCycle varchar(5);

BEGIN

	SELECT "billcycle" INTO v_billCycle FROM dswtdir2_bayan_dbo.billcycles WHERE cyclecode = p_cycleCode;
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_chargecode();
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_subscriber();
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_preload_pg(p_cyclecode);
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_reconphp_p();
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_reconusd_p();


END;
$procedure$
