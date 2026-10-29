CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zservice_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Swetha Neha 09/18/2020
Modified by: Swetha Neha 09/21/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zservice_typeupdsel
    SET zservice_type = zservice_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php main
    SET "zService_Type " = CASE
        WHEN lower(COALESCE(ref.service_type, ''::character varying)::text) = lower(''::text) 
            THEN main.column7
        ELSE ref.service_type
    END
    FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(t1.column6, ''::character varying)::text || COALESCE(t1.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE main.ctid = t1.ctid
      AND lower(main.column1::text) = lower('01'::text);
END;
$procedure$
