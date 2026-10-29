CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_bsid()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.bsid;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[BSID]
    			   (MANDT, BUKRS, KUNNR, ZUONR, GJAHR, BELNR, BUZEI, BUDAT, BLDAT, CPUDT, WAERS,XBLNR, BLART,BSCHL, SHKZG,
    			   DMBTR, WRBTR,  SGTXT, SAKNR, HKONT,DMBT1, WRBT1, MWSK2, DMBT2,WRBT2, MWSK3, DMBT3, WRBT3,
    			   DMBE2, DMBE3, DMB21, DMB22, DMB23, DMB31, DMB32,DMB33, MWST2, MWST3, SKNT2, SKNT3, BDIF3)
    	SELECT x.*
    	FROM OPENQUERY([SAP_S4],'Select "MANDT", "BUKRS", "KUNNR", "ZUONR", "GJAHR", "BELNR", "BUZEI", "BUDAT", "BLDAT", "CPUDT", "WAERS",
     "XBLNR", "BLART","BSCHL", "SHKZG", "DMBTR", "WRBTR",  "SGTXT", "SAKNR", "HKONT",
      "DMBT1", "WRBT1", "MWSK2", "DMBT2", "WRBT2", "MWSK3", "DMBT3", "WRBT3", "DMBE2", "DMBE3", "DMB21", "DMB22", "DMB23", "DMB31", "DMB32",
     "DMB33", "MWST2", "MWST3", "SKNT2", "SKNT3", "BDIF3" From "SAPPRD"."BSID"') x;
    */
END;
$procedure$
