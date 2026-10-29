CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_zbillmonths()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 09/25/2020
Modified by: Uma Guduru 09/25/2020
Description: Reset the zBillMonthStartDate_Override flag to 0 in zPARAM_ICCBS for TargetTable ttWireline_BT.
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_zbillmonthstartdate_override_reset_updsel
    SET zbillmonthstartdate_override = zbillmonthstartdate_overridenew;
END;
$procedure$
