CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trwireline_gt_delete_from_dcwireline_gt_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 08/27/2020
Modified by: Uma Guduru 08/28/2020
Description: Delete_From_dcWireline_GT
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trwireline_gt_delete_from_dcwireline_gt_delsel;
END;
$procedure$
