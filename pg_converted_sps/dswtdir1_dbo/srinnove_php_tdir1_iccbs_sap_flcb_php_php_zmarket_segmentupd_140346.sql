CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_php_zmarket_segmentupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/01/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_php_zmarket_segmentupdsel*/
    /*SET zmarket_segment = zmarket_segmentnew;*/
	UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET "zMarket_Segment " = CASE
        WHEN LOWER(COALESCE(zffi_prod_serv.market_segment, '')) = '' 
        THEN target_table.column8
        ELSE zffi_prod_serv.market_segment
    END
    FROM dswtdir1_dbo.zffi_prod_serv
    WHERE LOWER(COALESCE(target_table.column6, '') || COALESCE(target_table.column7, '')) = LOWER(zffi_prod_serv.zpl_st::text)
      AND LOWER(target_table.column1::text) = '01';
END;
$procedure$
