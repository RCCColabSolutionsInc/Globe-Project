CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_item_co()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/23/2020
Modified by: Sindhuja Beram 09/23/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_item_code_zffi_rev_servupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php main
    SET zrevenue_item_code = CASE
        WHEN lower(COALESCE(ref.revenue_itemcode, ''::character varying)::text) = lower(''::text) 
            THEN main.column9
        ELSE ref.revenue_itemcode
    END
    FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    LEFT JOIN dswtdir1_dbo.zffi_rev_serv ref 
        ON lower(COALESCE(t1.column9, ''::character varying)::text || COALESCE(t1."zService_Type ", ''::character varying)::text) = lower(ref.ric_st::text)
    WHERE main.ctid = t1.ctid
      AND lower(main.column1::text) = lower('01'::text)
      AND main.zrevenue_item_code IS NULL;
END;
$procedure$
