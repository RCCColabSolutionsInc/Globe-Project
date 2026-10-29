CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspa_rule2upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/26/2020
Modified by: Pradeep Gupta 11/26/2020
Description: Sub Product A for blank rows
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspa_rule2updsel
    SET zspa = zspanew;
END;
$procedure$
