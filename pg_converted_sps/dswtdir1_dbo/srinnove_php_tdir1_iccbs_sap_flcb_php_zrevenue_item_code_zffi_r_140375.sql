CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_item_code_zffi_r()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/23/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zrevenue_item_code_zffi_rev_servupdsel*/
    /*SET zrevenue_item_code = zrevenue_item_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zrevenue_item_code = CASE
        WHEN LOWER(COALESCE(zffi_rev_serv.revenue_itemcode, '')) = '' 
        THEN target_table.column9
        ELSE zffi_rev_serv.revenue_itemcode
    END
    FROM dswtdir1_dbo.zffi_rev_serv
    WHERE LOWER(COALESCE(target_table.column9, '') || COALESCE(target_table."zService_Type ", '')) = LOWER(zffi_rev_serv.ric_st::text)
      AND LOWER(target_table.column1::text) = '01'
      AND target_table.zrevenue_item_code IS NULL;
END;
$procedure$
