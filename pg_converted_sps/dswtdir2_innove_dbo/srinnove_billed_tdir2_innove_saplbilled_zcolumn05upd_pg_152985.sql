CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_billed_tdir2_innove_saplbilled_zcolumn05upd_pg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE dswtdir2_innove_dbo.saplbilled
    SET zColumn05 = zColumn05New;
END;
$procedure$
