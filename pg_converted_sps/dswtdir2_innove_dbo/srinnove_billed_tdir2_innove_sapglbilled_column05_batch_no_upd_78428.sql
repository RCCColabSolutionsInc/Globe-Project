CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_column05_batch_no_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 12/22/2020
Modified by: Pradeep Gupta 12/22/2020
Description: Batch No
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_sapglbilled_column05_batch_no_updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
