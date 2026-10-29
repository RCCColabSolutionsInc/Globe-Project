CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemo01_zerrormessage_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 07/06/2020
Modified by: Sindhuja Beram 07/06/2020
Description: Update zErrormessage based on all error flags
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemo01_zerrormessage_updsel
    SET zerrormessage = zerrormessagenew;
END;
$procedure$
