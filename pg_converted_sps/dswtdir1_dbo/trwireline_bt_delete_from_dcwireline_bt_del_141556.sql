CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trwireline_bt_delete_from_dcwireline_bt_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 09/07/2020
Modified by: Swetha Neha 09/07/2020
Description: Delete data from dcWireline
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trwireline_bt_delete_from_dcwireline_bt_delsel;
END;
$procedure$
