CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_credit_notequalto_debit_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/27/2021
Modified by: Uma Guduru 03/27/2021
Description: remediate Credit and Debit Values Are not Balanced.
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_credit_notequalto_debit_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
