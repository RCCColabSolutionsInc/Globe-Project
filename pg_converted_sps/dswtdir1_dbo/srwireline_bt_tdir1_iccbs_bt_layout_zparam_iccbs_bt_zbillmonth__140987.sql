CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_zbillmonth_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 09/25/2020
Modified by: Uma Guduru 09/25/2020
Description: Update zBillMonth in zParam_ICCBS based on zBillMonthStartDate_CustomValue, zBillMonthStartDate and zBillMonthStartDate_Override along with zBillMonth_CustomValue and zBillMonth_Override for ttWireline_BT.
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_zbillmonth_using_startdate_updsel
    SET zbillmonth = zbillmonthnew;
END;
$procedure$
