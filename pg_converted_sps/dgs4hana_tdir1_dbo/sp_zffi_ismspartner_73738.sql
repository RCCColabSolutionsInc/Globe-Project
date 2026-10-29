CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_ismspartner()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_ismspartner;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[ZFFI_ISMSPARTNER]
    			   (MANDT, SAP_CODE, COUNTER, PARTNER_NAME, SHORT_CODE, BOOKING_INBOUND, BOOKING_OUTBOUND)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "MANDT", "SAP_CODE", "COUNTER", "PARTNER_NAME", "SHORT_CODE", "BOOKING_INBOUND", "BOOKING_OUTBOUND" From "SAPPRD"."ZFFI_ISMSPARTNER"') x;
    */
END;
$procedure$
