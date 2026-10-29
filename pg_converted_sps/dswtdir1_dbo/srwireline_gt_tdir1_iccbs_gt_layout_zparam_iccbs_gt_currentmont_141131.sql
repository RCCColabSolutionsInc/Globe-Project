CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zparam_iccbs_gt_currentmont()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 08/20/2020
Modified by: Swetha Neha 08/27/2020
Description: Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zparam_iccbs_gt_currentmonth_eom_updsel
    SET zbillcycle = zbillcyclenew, zbillrundate = zbillrundatenew;
END;
$procedure$
