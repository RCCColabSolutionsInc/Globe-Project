CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zfranchise_area_a()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/20/2020
Modified by: Sindhuja Beram 09/20/2020
Description: Updates zFranchise Type to A when 0 or blank
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zfranchise_area_a_whnblnkorzeroupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
