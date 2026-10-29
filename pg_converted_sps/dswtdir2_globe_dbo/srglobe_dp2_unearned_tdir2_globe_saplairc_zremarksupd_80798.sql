CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zremarksupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/26/2020
Modified by: Pradeep Gupta 11/26/2020
Description: Remarks
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zremarksupdsel
    SET zremarks = zremarksnew;
END;
$procedure$
