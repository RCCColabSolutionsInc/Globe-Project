CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zproduct_groupup()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/23/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zproduct_groupup*/
    /*SET zproduct_group = zproduct_groupnew;*/
    UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zproduct_group = CASE
        WHEN LOWER(COALESCE(zffi_prod_serv.product_group, '')) = '' 
        THEN target_table.column6
        ELSE zffi_prod_serv.product_group
    END
    FROM dswtdir1_dbo.zffi_prod_serv
    WHERE LOWER(COALESCE(target_table.column6, '') || COALESCE(target_table.column7, '')) = LOWER(zffi_prod_serv.zpl_st::text)
      AND LOWER(target_table.column1::text) = '01';
END;
$procedure$
