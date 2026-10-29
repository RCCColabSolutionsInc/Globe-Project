CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_revenueaccount_notextended_tococdupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Uma Guduru 03/25/2021
Description: GL Revenue Account Not Extended to Company Code
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_revenueaccount_notextended_tococdupdsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
