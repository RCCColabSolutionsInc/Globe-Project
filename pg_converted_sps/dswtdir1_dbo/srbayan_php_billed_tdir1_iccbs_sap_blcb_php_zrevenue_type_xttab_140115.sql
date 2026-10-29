CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zrevenue_type_xttab()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Sindhuja Beram 08/26/2020
Description: Updates zRevenue_Type based   based on zRevenue_Item_Code , zService Type from xtTableC
*/
BEGIN
    UPDATE dswtdir1_dbo.srBayan_PHP_Billed_TDIR1_ICCBS_sap_blcb_PHP_zRevenue_Type_xtTableCUpdSel
    SET zRevenue_Type = zRevenue_TypeNew;
END;
$procedure$
