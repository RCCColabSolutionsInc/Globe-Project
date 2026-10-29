CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php main
    SET zrevenue_type = ref.revenue_type
    FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(t1.column6, ''::character varying)::text || COALESCE(t1.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE main.ctid = t1.ctid
      AND lower(main.column1::text) = lower('01'::text);
END;
$procedure$
