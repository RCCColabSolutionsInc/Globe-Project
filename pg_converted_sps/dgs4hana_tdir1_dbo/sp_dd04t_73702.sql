CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_dd04t()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.dd04t;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[DD04T]
    			   (ROLLNAME, DDLANGUAGE, AS4LOCAL, AS4VERS, DDTEXT, REPTEXT, SCRTEXT_S, SCRTEXT_M, SCRTEXT_L)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "ROLLNAME", "DDLANGUAGE", "AS4LOCAL", "AS4VERS", "DDTEXT", "REPTEXT", "SCRTEXT_S", "SCRTEXT_M", "SCRTEXT_L" From "SAPPRD"."DD04T"') x;
    */
END;
$procedure$
