CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zrevenue_item_coden()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Sindhuja Beram 08/26/2020
Description: Updates zRevenue_Item_Code  based on zRevenue_Item_Code , zService Type from xtTableC
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zrevenue_item_codenewupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;
END;
$procedure$
