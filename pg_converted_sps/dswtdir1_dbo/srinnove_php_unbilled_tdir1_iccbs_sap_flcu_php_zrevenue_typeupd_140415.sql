CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET zrevenue_type = zps.revenue_type
    FROM dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st_src
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv zps 
        ON LOWER(COALESCE(st_src.column6, ''::character varying)::text || COALESCE(st_src.column7, ''::character varying)::text) = LOWER(zps.zpl_st::text)
    WHERE st.ctid = st_src.ctid
      AND LOWER(st_src.column1::text) = LOWER('01'::text);
END;
$procedure$
