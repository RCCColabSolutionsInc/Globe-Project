CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_type_zf()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_type_zffi_rev_servupdsel
    SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php main
    SET zrevenue_type = ref.revenue_type
    FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv ref 
        ON lower(COALESCE(t1.zrevenue_item_code, ''::character varying)::text || COALESCE(t1."zService_Type ", ''::character varying)::text) = lower(ref.ric_st::text)
    WHERE main.ctid = t1.ctid
      AND lower(main.column1::text) = lower('01'::text)
      AND (
          main.zrevenue_type IS NULL 
          OR lower(trim(main.zrevenue_type::text)) = ''
      );
END;
$procedure$
