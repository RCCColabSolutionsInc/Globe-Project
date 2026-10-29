CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_item_co()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/23/2020
Modified by: Sindhuja Beram 09/23/2020
Description:
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_item_code_zffi_rev_servupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET zrevenue_item_code = CASE
        WHEN lower(COALESCE(ref.revenue_itemcode, ''::character varying)::text) = '' THEN target.column9
        ELSE ref.revenue_itemcode
    END
    FROM dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd base
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv ref 
        ON lower(COALESCE(base.column9, ''::character varying)::text || COALESCE(base."zService_Type ", ''::character varying)::text) = lower(ref.ric_st::text)
    WHERE target.ctid = base.ctid
      AND lower(target.column1::text) = lower('01'::text)
      AND target.zrevenue_item_code IS NULL;
END;
$procedure$
