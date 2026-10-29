CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zservice_typeupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Swetha Neha 09/17/2020
Modified by: Swetha Neha 09/21/2020
Description: Update Target from Source
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zservice_typeupdsel*/
    /*SET zservice_type = zservice_typenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET "zService_Type " = CASE
        WHEN LOWER(COALESCE(zps.service_type, ''::character varying)::text) = LOWER(''::text) THEN st.column7
        ELSE zps.service_type
    END
    FROM dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st_src
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv zps 
        ON LOWER(COALESCE(st_src.column6, ''::character varying)::text || COALESCE(st_src.column7, ''::character varying)::text) = LOWER(zps.zpl_st::text)
    WHERE st.ctid = st_src.ctid
      AND LOWER(st_src.column1::text) = LOWER('01'::text);
END;
$procedure$
