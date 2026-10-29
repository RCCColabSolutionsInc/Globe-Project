CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_export_dp1_billed_loadfilesel_dummy(IN p_cycle_code character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    TRUNCATE TABLE dswtdir2_bayan_dbo.tvbayan_billed_preload_cycleXrptsel_dummy_export;

    CREATE TEMP TABLE tmp_dummy_data (LIKE dswtdir2_bayan_dbo.tvbayan_billed_preload_cycleXrptsel_dummy_export) ON COMMIT DROP;

    INSERT INTO tmp_dummy_data (
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, 
        column11, column12, column13, column14, column15, column16, column17, column18, column19, 
        zdsp_order, zdsp_uniquekey, zlegacycycle_code
    ) VALUES 
    -- 11 Header Records (One for each Cycle Code)
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1679', '01072026', '221246', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC01'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1680', '06072026', '221247', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC06'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1681', '08072026', '221248', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC08'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1682', '10072026', '221249', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC10'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1683', '11072026', '221250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC11'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1684', '13072026', '221251', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC13'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1685', '16072026', '221252', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC16'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1686', '18072026', '221253', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC18'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1687', '21072026', '221254', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC21'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1688', '24072026', '221255', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC24'),
    ('00', 'AMAR', 'SAPFIGL', 'ARBC', '1689', '27072026', '221256', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 'BC27'),

    -- 77 Transaction Records (7 records for each cycle code)
    -- BC01
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/01/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/01/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/01/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/01/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/01/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/01/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/01/2026', 'BC01'),
    ('01', '07/01/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/01/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/01/2026', 'BC01'),
    -- BC06
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/06/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/06/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/06/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/06/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/06/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/06/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/06/2026', 'BC06'),
    ('01', '07/06/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/06/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/06/2026', 'BC06'),
    -- BC08
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/08/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/08/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/08/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/08/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/08/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/08/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/08/2026', 'BC08'),
    ('01', '07/08/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/08/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/08/2026', 'BC08'),
    -- BC10
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/10/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/10/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/10/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/10/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/10/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/10/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/10/2026', 'BC10'),
    ('01', '07/10/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/10/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/10/2026', 'BC10'),
    -- BC11
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/11/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/11/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/11/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/11/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/11/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/11/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/11/2026', 'BC11'),
    ('01', '07/11/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/11/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/11/2026', 'BC11'),
    -- BC13
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/13/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/13/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/13/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/13/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/13/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/13/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/13/2026', 'BC13'),
    ('01', '07/13/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/13/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/13/2026', 'BC13'),
    -- BC16
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/16/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/16/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/16/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/16/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/16/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/16/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/16/2026', 'BC16'),
    ('01', '07/16/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/16/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/16/2026', 'BC16'),
    -- BC18
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/18/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/18/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/18/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/18/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/18/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/18/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/18/2026', 'BC18'),
    ('01', '07/18/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/18/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/18/2026', 'BC18'),
    -- BC21
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/21/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/21/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/21/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/21/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/21/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/21/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/21/2026', 'BC21'),
    ('01', '07/21/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/21/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/21/2026', 'BC21'),
    -- BC24
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/24/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/24/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/24/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/24/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/24/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/24/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/24/2026', 'BC24'),
    ('01', '07/24/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/24/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/24/2026', 'BC24'),
    -- BC27
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', NULL, '07/27/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '2', 'BBilled-2-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', NULL, '07/27/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '3', 'BBilled-3-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'MSFFH_BP1199_5M', NULL, '-178.42', '0.00', NULL, '07/27/2026', 'PHP', 'U', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '4', 'BBilled-4-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'BILL_REBATE', NULL, '-701.11', '0.00', NULL, '07/27/2026', 'PHP', 'V', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '5', 'BBilled-5-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'MSFFH_GFU27997H', NULL, '2499.11', '0.00', NULL, '07/27/2026', 'PHP', 'R', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '6', 'BBilled-6-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'RC_UNLIBB_99', NULL, '88.39', '0.00', NULL, '07/27/2026', 'PHP', 'L', 'GPON', 'Bundle', NULL, NULL, NULL, NULL, '7', 'BBilled-7-07/27/2026', 'BC27'),
    ('01', '07/27/2026', '1', 'C', 'BBWL', 'MSFDH999_5M', NULL, '891.96', '0.00', NULL, '07/27/2026', 'PHP', 'V', 'GPON', 'DataOnlyPlan', NULL, NULL, NULL, NULL, '8', 'BBilled-8-07/27/2026', 'BC27');

    INSERT INTO dswtdir2_bayan_dbo.tvbayan_billed_preload_cycleXrptsel_dummy_export
    SELECT * FROM tmp_dummy_data
    WHERE zlegacycycle_code = p_cycle_code;

END;
$procedure$
