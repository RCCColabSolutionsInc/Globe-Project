CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_area_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/20/2020
Modified by: Sindhuja Beram 09/20/2020
Description: Updates zFranchise_Area to A when blank or zero
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_area_a_whnblnkorzeroupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
