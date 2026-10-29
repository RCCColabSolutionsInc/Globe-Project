CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_usd_billed_data_zloadedupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 10/12/2020
Modified by: Pradeep Gupta 10/12/2020
Description:  Update zLoaded Flag
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_usd_billed_data_zloadedupdsel
    SET zloaded = zloadednew;
END;
$procedure$
