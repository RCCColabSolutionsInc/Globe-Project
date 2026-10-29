CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrevenue_item_cod()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/24/2020
Modified by: Sindhuja Beram 09/24/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrevenue_item_code_zffi_rev_servupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;
END;
$procedure$
