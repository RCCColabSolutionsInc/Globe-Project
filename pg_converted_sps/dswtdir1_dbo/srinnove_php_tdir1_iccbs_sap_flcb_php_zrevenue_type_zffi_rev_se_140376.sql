CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_type_zffi_rev_se()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/01/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_type_zffi_rev_servupdsel*/
    /*SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zrevenue_type = zffi_rev_serv.revenue_type
    FROM dswtdir1_dbo.zffi_rev_serv
    WHERE LOWER(COALESCE(target_table.zrevenue_item_code, '') || COALESCE(target_table."zService_Type ", '')) = LOWER(zffi_rev_serv.ric_st::text)
      AND LOWER(target_table.column1::text) = '01'
      AND (
          target_table.zrevenue_type IS NULL 
          OR LOWER(TRIM(target_table.zrevenue_type::text)) = ''
      );
END;
$procedure$
