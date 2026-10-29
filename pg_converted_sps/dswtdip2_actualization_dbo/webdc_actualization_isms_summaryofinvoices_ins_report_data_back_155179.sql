CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.webdc_actualization_isms_summaryofinvoices_ins_report_data_back()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
-- Converted or applied with error!
-- ERROR: syntax error at or near ".3"
--  Position: 1309
-- BEGIN
--    INSERT INTO dswtdip2_actualization_dbo.dc_actualization_isms_summaryofinvoices ("Document Date", "Posting Date", "Company Code", "SAP CODE", "GL account", "BOOKING CURRENCY", "QTY (INVOICE)", "AMOUNT (INVOICE)", "QTY (DISPUTE)", "AMOUNT (DISPUTE)", "NET QTY", "NET AMOUNT", "3% VARIANCE", "INVOICE NUMBER", direction, zrownumber, zdsp_uniquekey, approve, status)
--    SELECT
--        tvtdip2_actualization_summaryofinvoices_ib_ob.Document Date, tvtdip2_actualization_summaryofinvoices_ib_ob.Posting Date, tvtdip2_actualization_summaryofinvoices_ib_ob.Company Code, tvtdip2_actualization_summaryofinvoices_ib_ob.SAP CODE, tvtdip2_actualization_summaryofinvoices_ib_ob.GL account, tvtdip2_actualization_summaryofinvoices_ib_ob.BOOKING CURRENCY, tvtdip2_actualization_summaryofinvoices_ib_ob.QTY (INVOICE), tvtdip2_actualization_summaryofinvoices_ib_ob.AMOUNT (INVOICE), tvtdip2_actualization_summaryofinvoices_ib_ob.QTY (DISPUTE), tvtdip2_actualization_summaryofinvoices_ib_ob.AMOUNT (DISPUTE), tvtdip2_actualization_summaryofinvoices_ib_ob.NET QTY, tvtdip2_actualization_summaryofinvoices_ib_ob.NET AMOUNT, tvtdip2_actualization_summaryofinvoices_ib_ob.3% VARIANCE, tvtdip2_actualization_summaryofinvoices_ib_ob.INVOICE NUMBER, tvtdip2_actualization_summaryofinvoices_ib_ob.DIRECTION, tvtdip2_actualization_summaryofinvoices_ib_ob.ZDSP_Order, tvtdip2_actualization_summaryofinvoices_ib_ob.ZDSP_uniquekey, tvtdip2_actualization_summaryofinvoices_ib_ob.Approve, tvtdip2_actualization_summaryofinvoices_ib_ob.Status
--        FROM tvTDIP2_Actualization_SummaryOfInvoices_IB_OB
--        LEFT OUTER JOIN dswtdip2_actualization_dbo.dc_actualization_isms_summaryofinvoices
--            ON dc_actualization_isms_summaryofinvoices.zrownumber = tvtdip2_actualization_summaryofinvoices_ib_ob.ZDSP_Order AND dc_actualization_isms_summaryofinvoices.direction = tvtdip2_actualization_summaryofinvoices_ib_ob.DIRECTION
--        WHERE (regexp_replace(tvtdip2_actualization_summaryofinvoices_ib_ob.3% VARIANCE, '%', '', 'gi') > 3) AND dc_actualization_isms_summaryofinvoices."Company Code" IS NULL
--        LIMIT 1000;
-- END;
END;
$procedure$
