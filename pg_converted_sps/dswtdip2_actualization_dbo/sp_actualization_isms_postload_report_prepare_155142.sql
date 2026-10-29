CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	RAISE NOTICE 'END PROCESS';
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_prepare_ib_ob_postcontrol();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_prepare_summary_ib_ob_postcontrol();
--    CALL dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_prepare_openbal();
END;
$procedure$
