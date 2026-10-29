CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scenario8m_rev_and_nonrev_isinv()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/28/2021
Modified by: Uma Guduru 03/28/2021
Description: Remediate Combination of Revenue GLs and Non-Revenue GLs must not exist for Scenario8M.
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scenario8m_rev_and_nonrev_isinvalid_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
