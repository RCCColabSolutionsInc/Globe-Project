CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_i()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 01/28/2021
Modified by: Elakki K 01/28/2021
Description: Update Invoice Date to Trim Timestamp
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invoice_dateupdsel
    SET invoice_date = invoice_datenew;
END;
$procedure$
