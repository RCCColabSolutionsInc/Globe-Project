CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/01/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
   /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_typeupdsel*/
    /*SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zrevenue_type = zffi_prod_serv.revenue_type
    FROM dswtdir1_dbo.zffi_prod_serv
    WHERE LOWER(COALESCE(target_table.column6, '') || COALESCE(target_table.column7, '')) = LOWER(zffi_prod_serv.zpl_st::text)
      AND LOWER(target_table.column1::text) = '01';
END;
$procedure$
