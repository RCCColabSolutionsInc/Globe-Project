CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.trinnove_unbilled_char_zloaded_0_error_lineupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 04/21/2021
Modified by: Pradeep Gupta 04/21/2021
Description: Update all records as not loaded if any error
*/
/*BEGIN
    UPDATE dswtdir2_innove_dbo.trinnove_unbilled_char_zloaded_0_error_lineupdsel
    SET zloaded = zloadednew;
END;*/
BEGIN
    UPDATE dswtdir2_innove_dbo.ttinnove_unbilled_char tt
    SET zloaded = 0  -- Set as numeric to fix type mismatch
    FROM dswtdir2_innove_dbo.innove_unbilled_char_zloaded_0_error_line err
    WHERE lower(tt.zsource::text) = lower(err.zsource::text);
END;
$procedure$
