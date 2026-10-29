CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_checkrowcount(IN par_qry text, INOUT par_rowcount integer)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    EXECUTE par_qry;
    /*
    [7833 - Severity CRITICAL - DMS SC can't convert the @@rowcount function in the current context. Convert your source code manually.]
    SET @rowcount = @@ROWCOUNT;
    */
END;
$procedure$
