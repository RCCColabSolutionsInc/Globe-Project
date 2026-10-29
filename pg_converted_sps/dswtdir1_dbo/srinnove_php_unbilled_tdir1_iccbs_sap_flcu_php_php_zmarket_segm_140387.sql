CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_php_zmarket_segm()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_php_zmarket_segmentupdsel
    SET zmarket_segment = zmarket_segmentnew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET "zMarket_Segment " = CASE
        WHEN LOWER(COALESCE(zps.market_segment, ''::character varying)::text) = LOWER(''::text) THEN st.column8
        ELSE zps.market_segment
    END
    FROM dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st_src
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv zps 
        ON LOWER(COALESCE(st_src.column6, ''::character varying)::text || COALESCE(st_src.column7, ''::character varying)::text) = LOWER(zps.zpl_st::text)
    WHERE st.ctid = st_src.ctid
      AND LOWER(st_src.column1::text) = LOWER('01'::text);
END;
$procedure$
