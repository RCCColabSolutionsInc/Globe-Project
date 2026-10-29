CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zactive_zprodu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/19/2020
Modified by: Sindhuja Beram 09/19/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zactive_zproductgroupupdsel
    SET zactive = zactivenew;
END;
$procedure$
