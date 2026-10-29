CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

-- Missing Tables
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_accrual_vs_apmi();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_apmi();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_ib_ob_precontrol();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_inbound_outbound_adjustment();
--		CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_invoices_summary_gt3var_approval();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_summary_vs_accrual_inbound();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_summary_vs_accrual();
--	CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_validation();
--	CALL dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_openbal_loadfile();
	RAISE NOTICE 'End Run';
END;
$procedure$
