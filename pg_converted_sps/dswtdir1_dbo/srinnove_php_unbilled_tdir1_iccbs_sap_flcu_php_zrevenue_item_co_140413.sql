CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_item_co()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/23/2020
Modified by: Sindhuja Beram 09/23/2020
Description:
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_item_code_zffi_rev_servupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET zrevenue_item_code = CASE
        WHEN LOWER(COALESCE(zrs.revenue_itemcode, ''::character varying)::text) = LOWER(''::text) THEN st.column9
        ELSE zrs.revenue_itemcode
    END
    FROM dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st_src
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv zrs 
        ON LOWER(COALESCE(st_src.column9, ''::character varying)::text || COALESCE(st_src."zService_Type ", ''::character varying)::text) = LOWER(zrs.ric_st::text)
    WHERE st.ctid = st_src.ctid
      AND LOWER(st_src.column1::text) = LOWER('01'::text)
      AND st_src.zrevenue_item_code IS NULL;
END;
$procedure$
