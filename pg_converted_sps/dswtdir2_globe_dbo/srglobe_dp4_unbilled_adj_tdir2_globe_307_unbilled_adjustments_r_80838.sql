CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_r()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/10/2021 11:42:09 AM
Description: Insert DP4_Unbilled_Adj into ttGlobe_DP4_Unbilled_Adj
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp4_unbilled_adj (zlegacydsp_order, posting_date, customer_type, customer_sub_type, primary_subscriber_type, adjustment_type, adjustment_code, "Adjustment Reason", amount, tax, amount_net, spa, rev_type, gl, spb, brand, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, posting_date, customer_type, customer_sub_type, primary_subscriber_type, adjustment_type, adjustment_code, "Adjustment Reason", amount, tax, amount_net, spa, rev_type, gl, spb, brand, remark, zdsp_order, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_ginssel;
END;
$procedure$
