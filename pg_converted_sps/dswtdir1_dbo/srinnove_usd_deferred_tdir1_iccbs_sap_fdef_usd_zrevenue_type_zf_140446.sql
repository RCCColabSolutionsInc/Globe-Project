CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_type_zf()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Swetha Neha 09/18/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_type_zffi_rev_servupdsel
    SET zrevenue_type = zrevenue_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET zrevenue_type = ref.revenue_type
    FROM dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd base
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv ref 
        ON lower(COALESCE(base.zrevenue_item_code, ''::character varying)::text || COALESCE(base."zService_Type ", ''::character varying)::text) = lower(ref.ric_st::text)
    WHERE target.ctid = base.ctid
      AND lower(target.column1::text) = lower('01'::text)
      AND (
          target.zrevenue_type IS NULL 
          OR lower(trim(target.zrevenue_type::text)) = ''
      );
END;
$procedure$
