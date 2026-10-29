CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_revgl_fields_zbrand_zsub_product_a_zrevenue_t()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/25/2021
Modified by: Uma Guduru 03/25/2021
Description: Blank out Revenue GL fields for Vendor and VAT Lines.
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_revgl_fields_zbrand_zsub_product_a_zrevenue_type_updsel
    SET zbrand = zbrandnew, zrevenue_type = zrevenue_typenew, zsub_product_a = zsub_product_anew, ztechnology = ztechnologynew;
END;
$procedure$
