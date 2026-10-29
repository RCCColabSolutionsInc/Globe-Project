CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zfranchise_area_a_w()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/20/2020
Modified by: Sindhuja Beram 09/20/2020
Description: Updates zFranchise Area to A when blank or zero
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zfranchise_area_a_whnblnkorzeroupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
