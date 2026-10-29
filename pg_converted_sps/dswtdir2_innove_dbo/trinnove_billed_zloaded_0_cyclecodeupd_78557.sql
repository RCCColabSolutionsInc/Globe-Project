CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.trinnove_billed_zloaded_0_cyclecodeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 04/21/2021
Modified by: Pradeep Gupta 04/21/2021
Description: -
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.trinnove_billed_zloaded_0_cyclecodeupdsel
    SET zloaded = zloadednew;
END;
$procedure$
