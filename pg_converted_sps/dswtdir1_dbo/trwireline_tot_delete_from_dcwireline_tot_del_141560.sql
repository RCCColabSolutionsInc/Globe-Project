CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trwireline_tot_delete_from_dcwireline_tot_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 09/07/2020
Modified by: Swetha Neha 09/07/2020
Description: Delete_From_dcWireline_TOT
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trwireline_tot_delete_from_dcwireline_tot_delsel;
END;
$procedure$
