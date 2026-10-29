CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_report_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDirectory VARCHAR(1000) DEFAULT E'F:\\BOA\\Transform\\Report\\TDIP2-IOT_DA_SSRS';
    var_CommaDelimitedSubsName VARCHAR(1000) DEFAULT 'IOT_DA_Preload';
BEGIN
    /* for clearing purpose */
    CALL etl_db_dbo.sp_report_export(var_FileDirectory, var_CommaDelimitedSubsName);
END;
$procedure$
