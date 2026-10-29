CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_billed_postload_report_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDirectory VARCHAR(1000) DEFAULT E'F:\\BOA\\Transform\\Report\\TDIR1-ICCBS\\Innove_SSRS';
    var_CommaDelimitedSubsName VARCHAR(1000) DEFAULT 'Innove_PHP_Billed_Postload_Error_MMYY,Innove_PHP_Billed_Postload_Valid_MMYY';
BEGIN
    CALL etl_db_dbo.sp_report_export(var_FileDirectory, var_CommaDelimitedSubsName);
END;
$procedure$
