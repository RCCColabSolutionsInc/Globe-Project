CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/22/2022
Description: Delete Summary Header IB and OB
*/
BEGIN
    DELETE FROM dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_delsel;
END;
$procedure$
