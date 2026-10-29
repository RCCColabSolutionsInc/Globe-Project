CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zsub_product_a_notint25a4_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/20/2021
Modified by: Uma Guduru 03/29/2021
Description: Sub Product A Not Maintained in T25A4
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zsub_product_a_notint25a4_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
