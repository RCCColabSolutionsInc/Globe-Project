CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 08/24/2022
Description: Insert Summary Header IB and OB
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.summary_ib_ob_summary_header (account_group, "Discount Scheme", "End of PRA", "Partner TADIG Code", "Service Covered", "Start of PRA")
    SELECT
        account_group, "Discount Scheme", "End of PRA", "Partner TADIG Code", "Service Covered", "Start of PRA"
        FROM dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_inssel;
END;
$procedure$
