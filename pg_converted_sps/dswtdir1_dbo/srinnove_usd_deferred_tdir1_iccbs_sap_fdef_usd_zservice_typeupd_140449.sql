CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zservice_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Swetha Neha 09/18/2020
Modified by: Swetha Neha 09/21/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zservice_typeupdsel
    SET zservice_type = zservice_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET "zService_Type " = CASE
        WHEN lower(COALESCE(ref.service_type, ''::character varying)::text) = '' THEN target.column7
        ELSE ref.service_type
    END
    FROM dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd base
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(base.column6, ''::character varying)::text || COALESCE(base.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE target.ctid = base.ctid
      AND lower(target.column1::text) = lower('01'::text);
END;
$procedure$
