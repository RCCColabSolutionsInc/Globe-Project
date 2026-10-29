CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_m_bbf433cd(IN p_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
DROP TABLE IF EXISTS tmp_temp;
	CREATE TEMP TABLE tmp_temp AS
	SELECT zLegacyDSP_Order,  
                          Data         AS Data,  
                          Posting_Date AS "Posting Date",  
                          SAPFIGL      AS SAPFIGL,  
                          CT           AS "Customer Type",  
                          ST           AS "Subscriber Type",  
                          CH_Code      AS "Charge Code",  
                          DP_Code      AS "Discount Code",  
                          Amount       AS Amount,  
                          Hits         AS Hits,  
                          UOM          AS UOM,  
                          Brand        AS Brand,  
                          SPA          AS SPA,  
                          Rev_Type     AS "Rev Type",  
                          GL_Code      AS GL,  
                          SPB          AS SPB,  
                          Remarks      AS Remarks
  FROM   ttGlobe_DP1_Billed  
  WHERE  Data = '01'  
         AND zLegacyCycle_Code = p_billcycle;


 DELETE FROM dbo.rpt_Preload_Report_DP1_Billed_ManualReport_Cache WHERE BillCycle = p_billcycle;

 INSERT INTO dbo.rpt_Preload_Report_DP1_Billed_ManualReport_Cache
           (zLegacyDSP_Order
           ,Data
           ,"Posting Date"
           ,SAPFIGL
           ,"Customer Type"
           ,"Subscriber Type"
           ,"Charge Code"
           ,"Discount Code"
           ,Amount
           ,Hits
           ,UOM
           ,Brand
           ,SPA
           ,"Rev Type"
           ,GL
           ,SPB
           ,Remarks
           ,BillCycle)
	SELECT zLegacyDSP_Order
		  ,Data
		  ,"Posting Date"
		  ,SAPFIGL
		  ,"Customer Type"
		  ,"Subscriber Type"
		  ,"Charge Code"
		  ,"Discount Code"
		  ,Amount
		  ,Hits
		  ,UOM
		  ,Brand
		  ,SPA
		  ,"Rev Type"
		  ,GL
		  ,SPB
		  ,Remarks
		  ,p_billcycle
	  FROM tmp_temp;
END;
$procedure$
