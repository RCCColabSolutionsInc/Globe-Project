CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcust_class_codeup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 07/23/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcust_class_codeup AS target_table*/
    /*SET zcust_class_code = zcust_class_codenew;*/
    UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zcust_class_code = CASE
        WHEN LOWER(COALESCE(zffi_prod_serv.customer_class, '')) = '' 
        THEN target_table.column3
        ELSE zffi_prod_serv.customer_class
    END
    FROM dswtdir1_dbo.zffi_prod_serv
    WHERE LOWER(COALESCE(target_table.column6, '') || COALESCE(target_table.column7, '')) = LOWER(zffi_prod_serv.zpl_st::text)
      AND LOWER(target_table.column1::text) = '01';
END;
$procedure$
