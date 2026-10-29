CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_rpt_iot_da_report_ssrs_pg(IN par_accountgroup character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	RAISE NOTICE 'End Process';

--    OPEN p_refcur FOR
--    SELECT
--        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30, column31, column32, column33, column34, column35, column36, column37, column38, column39, column40, column41, column42, column43, column44, column45, column46, column47, column48, column49, column50, column51, column52, column53, column54, column55, column56, column57, column58, column59, column60, column61, column62, column63, column64, column65, column66, column67, column68, column69, column70, column71, column72, column73, accountgroup, sequenceid
--        FROM dswtdip2_iot_da_dbo.rpt_iot_da_report_prepare_cache
--        WHERE LOWER(accountgroup) = LOWER(par_AccountGroup)
--        ORDER BY accountgroup NULLS FIRST, sequenceid NULLS FIRST;
END;
$procedure$
