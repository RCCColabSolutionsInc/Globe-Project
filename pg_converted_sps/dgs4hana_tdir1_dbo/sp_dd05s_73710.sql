CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_dd05s()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.dd05s;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[DD05S]
    			   (TABNAME, FIELDNAME, PRIMPOS, AS4LOCAL, AS4VERS, FORTABLE, FORKEY, FORSTRING)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "TABNAME", "FIELDNAME", "PRIMPOS", "AS4LOCAL", "AS4VERS", "FORTABLE", "FORKEY", "FORSTRING" From "SAPPRD"."DD05S"') x;
    */
END;
$procedure$
