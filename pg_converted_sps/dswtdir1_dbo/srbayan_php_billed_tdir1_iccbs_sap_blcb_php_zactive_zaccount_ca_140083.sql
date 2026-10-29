CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zactive_zaccount_ca()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/19/2020
Modified by: Sindhuja Beram 09/19/2020
Description: removes Account group J and IN with product group 11000 and 12000
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zactive_zaccount_categoryupdsel
    SET zactive = zactivenew;
END;
$procedure$
