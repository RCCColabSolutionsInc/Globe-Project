CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_dd08l()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.dd08l;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[DD08L]
    			   (TABNAME, FIELDNAME, AS4LOCAL, AS4VERS, CHECKTABLE, FRKART, CLASFIELD, CLASVALUE, CARDLEFT, [CARD], CHECKFLAG, ARBGB, MSGNR, NOINHERIT)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "TABNAME", "FIELDNAME", "AS4LOCAL", "AS4VERS", "CHECKTABLE", "FRKART", "CLASFIELD", "CLASVALUE", "CARDLEFT", "CARD", "CHECKFLAG", "ARBGB", "MSGNR", "NOINHERIT" From "SAPPRD"."DD08L"') x;
    */
END;
$procedure$
