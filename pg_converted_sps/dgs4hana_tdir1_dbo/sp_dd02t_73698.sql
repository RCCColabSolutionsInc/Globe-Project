CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_dd02t()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.dd02t;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[DD02T]
    			   (TABNAME, DDLANGUAGE, AS4LOCAL, AS4VERS, DDTEXT)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select TABNAME, DDLANGUAGE, AS4LOCAL, AS4VERS, DDTEXT From SAPPRD.DD02T') x;
    */
END;
$procedure$
