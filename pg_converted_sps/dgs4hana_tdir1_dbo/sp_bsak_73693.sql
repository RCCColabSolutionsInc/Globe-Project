CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_bsak()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.bsak;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[BSAK]
    			   ([MANDT],
    			   [BUKRS],
    			   [LIFNR],
    			   [UMSKS],
    			   [UMSKZ],
    			   [AUGDT],
    			   [MONAT],
    			   [SHKZG],
    			   [BSCHL],
    			   [GJAHR],
    			   [BELNR],
    			   [BLDAT],
    			   [XBLNR],
    			   [BLART],
    			   [SKFBT],
    			   [AUGBL],
    			   [XREF3],
    			   [SGTXT],
    			   [QBSHB],
    			   [WRBTR],
    			   [ZUONR],
    			   [BUZEI],
    			   [WAERS],
    			   [GHKON])
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'select MANDT, BUKRS, LIFNR, UMSKS, UMSKZ, AUGDT, MONAT, SHKZG, BSCHL, GJAHR, BELNR, BLDAT, XBLNR, BLART, SKFBT, AUGBL, XREF3, SGTXT, QBSHB, WRBTR, ZUONR, BUZEI,WAERS,GHKON From SAPPRD.BSAK Where GJAHR > ''2018''') x;
    */
END;
$procedure$
