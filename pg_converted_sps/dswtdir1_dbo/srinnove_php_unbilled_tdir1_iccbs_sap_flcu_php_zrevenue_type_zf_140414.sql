CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_type_zf()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zrevenue_type_zffi_rev_servupdsel
    SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET zrevenue_type = zrs.revenue_type
    FROM dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st_src
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv zrs 
        ON LOWER(COALESCE(st_src.zrevenue_item_code, ''::character varying)::text || COALESCE(st_src."zService_Type ", ''::character varying)::text) = LOWER(zrs.ric_st::text)
    WHERE st.ctid = st_src.ctid
      AND LOWER(st_src.column1::text) = LOWER('01'::text)
      AND (
          st_src.zrevenue_type IS NULL 
          OR LOWER(RTRIM(LTRIM(st_src.zrevenue_type::text))) = LOWER(''::text)
      );
END;
$procedure$
