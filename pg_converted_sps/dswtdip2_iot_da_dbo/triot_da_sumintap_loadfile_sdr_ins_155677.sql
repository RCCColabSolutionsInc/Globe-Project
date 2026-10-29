CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 09/14/2022
Modified by: Yash Raturi 09/14/2022
Description: Insert into Sumintap Load File Sub
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.sumintap_loadfile_sdr_table (account_group, brand, column1, copa, diff_sdr, direction, exchange_rate, partner_company, racct, "REVENUE TYPE", "SUBPROD A", wwspb_pa)
    SELECT
        account_group, brand, column1, copa, diff_sdr, direction, exchange_rate, partner_company, racct, "REVENUE TYPE", "SUBPROD A", wwspb_pa
        FROM dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_inssel;
END;
$procedure$
