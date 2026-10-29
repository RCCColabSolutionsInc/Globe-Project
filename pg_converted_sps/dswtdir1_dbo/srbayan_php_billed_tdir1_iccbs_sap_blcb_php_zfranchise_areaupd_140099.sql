CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zfranchise_areaupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/21/2020 12:21:03 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Billed_TDIR1_ICCBS_sap_blcb_PHP:sap_blcb_PHP:zFranchise_Area
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zfranchise_areaupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
