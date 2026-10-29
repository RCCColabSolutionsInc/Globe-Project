CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerror_r2scenarios8r8m9and10_notready_forprod()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/22/2021
Modified by: Uma Guduru 03/22/2021
Description: Remediate message for R1 Prod runs: R2Scenarios8R8M9AND10_NotReady_ForPROD - Pending_GoLive.
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerror_r2scenarios8r8m9and10_notready_forprod_updsel
    SET zerrormessage = zerrormessagenew;
END;
$procedure$
