CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcust_class_code()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/28/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcust_class_codeupdsel
    SET zcust_class_code = zcust_class_codenew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET zcust_class_code = CASE
        WHEN lower(COALESCE(ref.customer_class, ''::character varying)::text) = '' THEN target.column3
        ELSE ref.customer_class
    END
    FROM dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd base
    LEFT JOIN dswtdir1_dbo.zffi_prod_serv ref 
        ON lower(COALESCE(base.column6, ''::character varying)::text || COALESCE(base.column7, ''::character varying)::text) = lower(ref.zpl_st::text)
    WHERE target.ctid = base.ctid
      AND lower(target.column1::text) = lower('01'::text);
END;
$procedure$
