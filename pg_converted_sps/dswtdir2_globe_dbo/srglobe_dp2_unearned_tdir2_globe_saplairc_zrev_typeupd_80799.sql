CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zrev_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/23/2020
Modified by: Pradeep Gupta 11/23/2020
Description: Revenue Type
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zrev_typeupdsel
    SET zrev_type = zrev_typenew;
END;
$procedure$
