CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_header_footerupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Sindhuja Beram 08/26/2020
Description: Updates Header and Footer for zCust_Class_Code , zProduct_Group, zService_type
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_header_footerupdsel
    SET zproduct_group = zproduct_groupnew;
END;
$procedure$
