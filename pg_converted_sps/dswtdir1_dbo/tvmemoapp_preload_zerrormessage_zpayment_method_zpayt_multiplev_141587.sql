CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zpayment_method_zpayt_multiplev()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/27/2021
Modified by: Uma Guduru 03/27/2021
Description: r2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zpayment_method_zpayt_multiplevalues_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
