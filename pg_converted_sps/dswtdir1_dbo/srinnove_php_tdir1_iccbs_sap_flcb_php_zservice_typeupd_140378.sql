CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zservice_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Swetha Neha 09/17/2020
Modified by: Swetha Neha 09/21/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zservice_typeupdsel*/
    /*SET zservice_type = zservice_typenew;*/
    UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET "zService_Type " = CASE
        WHEN LOWER(COALESCE(zffi_prod_serv.service_type, '')) = '' 
        THEN target_table.column7
        ELSE zffi_prod_serv.service_type
    END
    FROM dswtdir1_dbo.zffi_prod_serv
    WHERE LOWER(COALESCE(target_table.column6, '') || COALESCE(target_table.column7, '')) = LOWER(zffi_prod_serv.zpl_st::text)
      AND LOWER(target_table.column1::text) = '01';
END;
$procedure$
