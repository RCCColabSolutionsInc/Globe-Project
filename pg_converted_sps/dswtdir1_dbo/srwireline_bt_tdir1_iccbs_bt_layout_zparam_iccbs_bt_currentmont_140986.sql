CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_currentmont()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 09/03/2020
Modified by: Swetha Neha 09/03/2020
Description: Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zparam_iccbs_bt_currentmonth_eom_updsel
    SET zbillcycle = zbillcyclenew, zbillrundate = zbillrundatenew;
END;
$procedure$
