CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_dd03t()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.dd03t;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[DD03T]
    			   (TABNAME, DDLANGUAGE, AS4LOCAL, FIELDNAME, DDTEXT)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "TABNAME", "DDLANGUAGE", "AS4LOCAL", "FIELDNAME", "DDTEXT" From "SAPPRD"."DD03T"') x;
    */
END;
$procedure$
