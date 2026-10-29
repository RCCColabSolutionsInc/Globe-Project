CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zmarket_segm()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/04/2020
Modified by: Sindhuja Beram 09/04/2020
Description: Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zmarket_segmentupdsel
    SET zmarket_segment = zmarket_segmentnew;
END;
$procedure$
