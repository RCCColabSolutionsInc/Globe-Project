CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zactive_testi()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 07/23/2020
Modified by: Saketh Venkata Nadurumati 07/23/2020
Description: Delete this rule once the testing is complete
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendor_zactive_testingphaseupdsel
    SET zactive = zactivenew;
END;
$procedure$
