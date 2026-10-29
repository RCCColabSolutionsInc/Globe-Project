CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zwithholding_tax_base_absupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/08/2020
Modified by: Elakki K 09/08/2020
Description: Absolute of Withholding Tax Base
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zwithholding_tax_base_absupdsel
    SET zwithholding_tax_base = zwithholding_tax_basenew;
END;
$procedure$
