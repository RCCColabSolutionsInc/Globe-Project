CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zproduct_groupup()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/28/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zproduct_groupupdsel
    SET zproduct_group = zproduct_groupnew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET zproduct_group = CASE
        WHEN lower(COALESCE(ref.product_group, ''::character varying)::text) = '' THEN target.column6
        ELSE ref.product_group
    END
    FROM dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd base
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(base.column6, ''::character varying)::text || COALESCE(base.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE target.ctid = base.ctid
      AND lower(target.column1::text) = lower('01'::text);
END;
$procedure$
