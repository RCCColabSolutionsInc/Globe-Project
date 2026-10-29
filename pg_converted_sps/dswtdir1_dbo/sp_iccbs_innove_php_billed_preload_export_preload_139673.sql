CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_billed_preload_export_preload(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey
        FROM dswtdir1_dbo.txinnove_php_billed_exportsel
        ORDER BY column01 NULLS FIRST,
        CASE
            WHEN aws_sqlserver_ext.ISNUMERIC(zdsp_order) THEN CAST (zdsp_order AS INTEGER)
            ELSE NULL
        END NULLS FIRST;
END;
$procedure$
