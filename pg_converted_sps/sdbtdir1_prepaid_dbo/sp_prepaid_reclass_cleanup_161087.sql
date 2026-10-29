CREATE OR REPLACE PROCEDURE sdbtdir1_prepaid_dbo.sp_prepaid_reclass_cleanup()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.billed_adjustments_header_cycles;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.billed_adjustments_lineitem_cycles;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.billed_charges_header_cycles;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.billed_charges_lineitem_cycles;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcmonthlyrechargesummary;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dccallcard_sg;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcload_api;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcload_api_sg;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcload_up;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcload_up_sg;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcmanualcallcard;
    TRUNCATE TABLE sdbtdir1_prepaid_dbo.dcke24;
END;
$procedure$
