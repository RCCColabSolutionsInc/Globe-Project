CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcust_class_code()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/27/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcust_class_codeupdsel
    SET zcust_class_code = zcust_class_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php main
    SET zcust_class_code = CASE
        WHEN lower(COALESCE(ref.customer_class, ''::character varying)::text) = lower(''::text) 
            THEN main.column3
        ELSE ref.customer_class
    END
    FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(t1.column6, ''::character varying)::text || COALESCE(t1.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE main.ctid = t1.ctid
      AND lower(main.column1::text) = lower('01'::text);
END;
$procedure$
