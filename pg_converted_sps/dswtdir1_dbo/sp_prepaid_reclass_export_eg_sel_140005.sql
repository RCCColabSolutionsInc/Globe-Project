CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_prepaid_reclass_export_eg_sel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT 'Batch Number'
    		  ,'Doc Date'
    		  ,'Posting Date'
    		  ,'DocType'
    		  ,'Company Code'
    		  ,'Currency'
    		  ,'Date'
    		  ,'Fiscal Period'
    		  ,'Reference Document Number'
    		  ,'Text'
    		  ,'Posting Key'
    		  ,'Special G/L indicator'
    		  ,'Account or Matchcode for theNext Line Item'
    		  ,'Reconciliation G/L account'
    		  ,'Amount in local currency'
    		  ,'Tax on Sales/Purchases Code'
    		  ,'I/O Number'
    		  ,'Cost center'
    		  ,'Profit center'
    		  ,'Pegging flag'
    		  ,'Text2'
    		  ,'exchange rate'
    		  ,'trading partner'
    		  ,'Partner profit center'
    		  ,'Quantity'
    		  ,'UOM'
    		  ,'BRAND'
    		  ,'CFU'
    		  ,'sub-product -B'
    		  ,'Franchise Area'
    		  ,'Business Centre'
    		  ,'Revenue/Sales Type'
    		  ,'Event/Segment'
    		  ,'Payment Term'
    		  ,'Payment Method'
    		  ,'MVNO PARTNER'
    		  ,'TECHNOLOGY'
    		  ,'PLAN TYPE'
    		  ,'CORE PRODUCT'
    		  ,'REVENUE ITEM CODE'
    UNION ALL
    SELECT CAST([Batch Number] as NVARCHAR(20))
          ,[Doc Date]
          ,[Posting Date]
          ,[DocType]
          ,[Company Code]
          ,[Currency]
          ,[Date]
          ,[Fiscal Period]
          ,[Reference Document Number]
          ,[Text]
          ,CAST([Posting Key] as NVARCHAR(20))
          ,[Special G/L indicator]
          ,[Account or Matchcode for theNext Line Item]
          ,[Reconciliation G/L account]
    	  ,REPLACE(FORMAT([Amount in local currency], 'N2'), ',', '')
          ,[Tax on Sales/Purchases Code]
          ,[I/O Number]
          ,[Cost center]
          ,[Profit center]
          ,[Pegging flag]
          ,[Text2]
          ,[exchange rate]
          ,[trading partner]
          ,[Partner profit center]
          ,FORMAT([Quantity],'G')
          ,[UOM]
          ,[BRAND]
          ,[CFU]
          ,[sub-product -B]
          ,[Franchise Area]
          ,[Business Centre]
          ,[Revenue/Sales Type]
          ,[Event/Segment]
          ,[Payment Term]
          ,[Payment Method]
          ,[MVNO PARTNER]
          ,[TECHNOLOGY]
          ,[PLAN TYPE]
          ,[CORE PRODUCT]
          ,[REVENUE ITEM CODE]
      FROM [dbo].[txPrepaid_JV_EGSel]
    */
    BEGIN
    END;
END;
$procedure$
