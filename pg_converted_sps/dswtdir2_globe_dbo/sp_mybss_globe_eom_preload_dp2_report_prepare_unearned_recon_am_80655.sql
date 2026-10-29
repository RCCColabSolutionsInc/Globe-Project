CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_recon_am()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT FORMAT(Round(Sum(Cast([Total Unearned RC] AS FLOAT)), 2), '###,###,#00.00') AS [Total Unearned]
      ,FORMAT((
        SELECT Sum((Cast(Round(Column7, 2) AS FLOAT)))
        FROM sdbTDIR2_Globe..SAP_AIRC
        WHERE Column1 = '01'
        ), '###,###,#00.00') AS Total_SAP_AIRC
      ,FORMAT((Round(Sum(Cast([Total Unearned RC] AS FLOAT)), 2)) - (
        SELECT Sum((Cast(Round(Column7, 2) AS FLOAT)))
        FROM sdbTDIR2_Globe..SAP_AIRC
        WHERE Column1 = '01'
        ), '###,###,#00.00') AS Difference
        INTO #tvGlobe_DP2_Unearned_Recon_AmountRptSel
     FROM [324_Unearned_MSF_Header_Item];
    */
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache ("Total Unearned", total_sap_airc, difference)
    SELECT
        "Total Unearned", total_sap_airc, difference
        FROM t$tvglobe_dp2_unearned_recon_amountrptsel;
    /*
    
    DROP TABLE IF EXISTS t$tvglobe_dp2_unearned_recon_amountrptsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
