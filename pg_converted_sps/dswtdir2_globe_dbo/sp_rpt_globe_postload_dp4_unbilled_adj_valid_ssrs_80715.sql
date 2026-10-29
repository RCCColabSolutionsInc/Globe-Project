CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_postload_dp4_unbilled_adj_valid_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "batch no", "Doc. Date", "Post Date", "Doc. Type", "Co. Code", currency, "Translation Date", period, reference, "Doc.Hdr.Text", "Posting Key", "Spcl GL indicator", "GL/SL code", "Reconciliation G/L account", amount, "Tax Code", "IO number", "Cost Center", "Profit Center", "Assign.", "Text ", rate, "Trading Partner", "Partner profit center", quantity, uom, brand, "Sub-product A", "sub-product B", "Franchise Area", "Business Centre", "Revenue/Sales Type", "Event/Segment", "Payment Term", "Payment Method", "MVNO PARTNER", technology, "PLAN TYPE", "CORE PRODUCT", "REVENUE ITEM CODE", zdsp_order, zdsp_uniquekey, posting_log_message
        FROM dswtdir2_globe_dbo.rpt_postload_report_dp4_unbilled_adj_valid_cache
    /* ORDER BY zDSP_UniqueKey */
    ;
END;
$procedure$
