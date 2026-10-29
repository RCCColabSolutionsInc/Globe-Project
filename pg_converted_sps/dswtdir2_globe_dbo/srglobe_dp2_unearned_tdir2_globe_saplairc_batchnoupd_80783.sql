CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_batchnoupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 01/14/2021
Modified by: Pradeep Gupta 01/14/2021
Description: Updating Batch No
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_batchnoupdsel
    SET zst = zstnew;
END;
$procedure$
