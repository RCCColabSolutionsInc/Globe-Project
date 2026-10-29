CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zproductgroupupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Sindhuja Beram 08/26/2020
Description: Updates zProduct_Group based on zProduct_Group , zService_Type from xtTableB
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zproductgroupupdsel
    SET zproduct_group = zproduct_groupnew;
END;
$procedure$
