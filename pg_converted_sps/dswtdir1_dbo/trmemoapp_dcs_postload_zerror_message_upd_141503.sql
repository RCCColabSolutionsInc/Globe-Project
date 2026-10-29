CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_zerror_message_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 11/23/2020
Modified by: Elakki K 12/22/2020
Description: Update zErrorMessage Flag
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_dcs_postload_zerror_message_updsel
    SET boastatus = boastatusnew, changedby = changedbynew, changedon = changedonnew, zapprovalstatus = zapprovalstatusnew, zcounterapproved = zcounterapprovednew, zcountersubmitted = zcountersubmittednew, zerrormessage_load = zerrormessage_loadnew, zlineitemapproved = zlineitemapprovednew, zlineitemsubmitted = zlineitemsubmittednew, zloaded = zloadednew;
END;
$procedure$
