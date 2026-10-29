CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_areau()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/18/2020 12:57:17 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Deferred_TDIR1_ICCBS_sap_fdef_PHP:sap_fdef_PHP:zFranchise_Area
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_areaupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
