CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.trinnove_unearned_msf_zloaded_0_error_lineupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 04/21/2021
Modified by: Pradeep Gupta 04/21/2021
Description: Update all records as not loaded if any error
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.trinnove_unearned_msf_zloaded_0_error_lineupdsel
    SET zloaded = zloadednew;
END;
$procedure$
