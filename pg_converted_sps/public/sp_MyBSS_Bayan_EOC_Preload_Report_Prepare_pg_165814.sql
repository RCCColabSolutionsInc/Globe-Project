CREATE OR REPLACE PROCEDURE public."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_pg"(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_BillCycle varchar(5);
BEGIN

    SELECT "BillCycle" INTO v_BillCycle FROM "BillCycles" WHERE "CycleCode" = p_CycleCode;

    --CALL "dbo"."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing"();
    --CALL "dbo"."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing"();
    --CALL "dbo"."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Preload"('BC01');
    --CALL "dbo"."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP"();
    --CALL "dbo"."sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD"();

    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_chargecode();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_subscriber();
    --CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_preload(var_BillCycle);
	CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_preload('BC01');
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_reconphp();
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_reconusd();

END;
$procedure$
