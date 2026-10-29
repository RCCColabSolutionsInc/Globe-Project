CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_postload_error_ssrs_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    var_BCCode VARCHAR(5) := 'BC01';
BEGIN
    SELECT
        billcycle
        INTO var_BCCode
        FROM dswtdir2_bayan_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
--    OPEN p_refcur FOR
--    SELECT
--        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, billcycle
--        FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache
--        WHERE LOWER(billcycle) = LOWER(var_BCCode)
--        ORDER BY column01 NULLS FIRST,
--        CASE
--            WHEN aws_sqlserver_ext.ISNUMERIC(zdsp_order) THEN CAST (zdsp_order AS INTEGER)
--            ELSE NULL
--        END NULLS FIRST;
END;
$procedure$
