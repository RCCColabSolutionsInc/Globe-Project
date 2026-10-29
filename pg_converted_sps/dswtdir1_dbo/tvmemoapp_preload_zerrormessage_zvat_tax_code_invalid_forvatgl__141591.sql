CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zvat_tax_code_invalid_forvatgl_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/27/2021
Modified by: Uma Guduru 03/27/2021
Description: remediate VAT Code can only be 0A/0C/0E/O1 For VAT GL.
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zvat_tax_code_invalid_forvatgl_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
